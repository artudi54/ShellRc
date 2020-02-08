"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const ws_1 = __importDefault(require("ws"));
const vscode = __importStar(require("vscode"));
const strip_ansi_1 = __importDefault(require("strip-ansi"));
const config_1 = require("./config");
const logger_1 = require("./logger");
const tasks_1 = require("./tasks");
class WebSocketClient {
    constructor(url) {
        this.url = url;
        this.autoReconnectInterval = 1 * 1000; // ms
        this._onOpen = new vscode.EventEmitter();
        this.onOpen = this._onOpen.event;
        this._onError = new vscode.EventEmitter();
        this.onError = this._onError.event;
        this._onClose = new vscode.EventEmitter();
        this.onClose = this._onClose.event;
        this._onMessage = new vscode.EventEmitter();
        this.onMessage = this._onMessage
            .event;
        this._onLog = new vscode.EventEmitter();
        this.onLog = this._onLog.event;
    }
    open() {
        this.instance = new ws_1.default(this.url);
        this.instance.on('open', () => {
            this.autoReconnectInterval = 1000;
            this._onOpen.fire();
        });
        this.instance.on('message', (data) => {
            this._onMessage.fire(data);
        });
        this.instance.on('close', code => {
            // CLOSE_NORMAL
            if (code !== 1000) {
                this.reconnect();
            }
            this._onClose.fire(code);
        });
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        this.instance.on('error', (err) => {
            if (err.code === 'ECONNREFUSED') {
                this.reconnect();
            }
            else {
                this._onError.fire(err);
            }
        });
    }
    send(data, callback) {
        try {
            this.instance.send(data, callback);
        }
        catch (err) {
            this.instance.emit('error', err);
        }
    }
    reconnect() {
        this._onLog.fire(`WebSocketClient: retry in ${this.autoReconnectInterval}ms`);
        this.instance.removeAllListeners();
        this.reconnectTimeout = setTimeout(() => this.open(), this.autoReconnectInterval);
        if (this.autoReconnectInterval < 5000) {
            this.autoReconnectInterval += 1000;
        }
    }
    dispose() {
        var _a, _b;
        if (this.reconnectTimeout) {
            clearTimeout(this.reconnectTimeout);
        }
        (_a = this.instance) === null || _a === void 0 ? void 0 : _a.removeAllListeners();
        (_b = this.instance) === null || _b === void 0 ? void 0 : _b.close();
        this._onClose.dispose();
        this._onError.dispose();
        this._onLog.dispose();
        this._onMessage.dispose();
        this._onOpen.dispose();
    }
    getInstance() {
        return this.instance;
    }
}
class Message {
    constructor(message) {
        this.message = message;
    }
    toString() {
        return JSON.stringify(this.message);
    }
}
class GradleTasksClient {
    constructor(server, statusBarItem) {
        this.server = server;
        this.statusBarItem = statusBarItem;
        this._onConnect = new vscode.EventEmitter();
        this.onConnect = this._onConnect.event;
        this._onGradleProgress = new vscode.EventEmitter();
        this.onGradleProgress = this
            ._onGradleProgress.event;
        this._onGradleOutput = new vscode.EventEmitter();
        this.onGradleOutput = this
            ._onGradleOutput.event;
        this._onGradleError = new vscode.EventEmitter();
        this.onGradleError = this
            ._onGradleError.event;
        this._onActionCancelled = new vscode.EventEmitter();
        this.onActionCancelled = this
            ._onActionCancelled.event;
        this._onMessage = new vscode.EventEmitter();
        this.onMessage = this._onMessage
            .event;
        this.handleServerStopped = () => {
            this.statusBarItem.hide();
        };
        this.connect = () => {
            if (this.wsClient) {
                this.wsClient.dispose();
            }
            logger_1.logger.info('Gradle client connecting to server...');
            const opts = this.server.getOpts();
            const port = this.server.getPort();
            this.wsClient = new WebSocketClient(`ws://${opts.host}:${port}`);
            this.wsClient.onMessage(this.handleMessage);
            this.wsClient.onOpen(() => this._onConnect.fire());
            this.wsClient.onError(this.handleError);
            this.wsClient.onLog((data) => logger_1.logger.info(data));
            this.wsClient.open();
        };
        this.handleError = (e) => {
            logger_1.logger.error(`Error connecting to gradle server: ${e.message}`);
            this.server.showRestartMessage();
        };
        this.handleProgressMessage = (message) => {
            var _a;
            const messageStr = (_a = message.message) === null || _a === void 0 ? void 0 : _a.trim();
            if (messageStr) {
                this.statusBarItem.text = `$(sync~spin) Gradle: ${messageStr}`;
            }
        };
        this.handleOutputMessage = (message) => {
            const logMessage = strip_ansi_1.default(message.message).trim();
            if (logMessage) {
                logger_1.logger.info(logMessage);
            }
        };
        this.handleMessage = (data) => {
            var _a;
            let serverMessage;
            try {
                serverMessage = JSON.parse(data.toString());
                if (config_1.getIsDebugEnabled()) {
                    logger_1.logger.debug(data.toString());
                }
            }
            catch (e) {
                logger_1.logger.error(`Unable to parse message from server: ${e.message}`);
                return;
            }
            this._onMessage.fire(serverMessage);
            switch (serverMessage.type) {
                case 'GRADLE_PROGRESS':
                    this._onGradleProgress.fire(serverMessage);
                    break;
                case 'GRADLE_OUTPUT':
                    this._onGradleOutput.fire(serverMessage);
                    break;
                case 'ERROR':
                    this._onGradleError.fire(serverMessage);
                    break;
                case 'ACTION_CANCELLED':
                    this._onActionCancelled.fire(serverMessage);
                    break;
                case 'GENERIC_MESSAGE':
                    const message = (_a = serverMessage.message) === null || _a === void 0 ? void 0 : _a.trim();
                    if (message) {
                        logger_1.logger.info(message);
                    }
                    break;
                default:
                    break;
            }
        };
        this.onGradleProgress(this.handleProgressMessage);
        this.onGradleOutput(this.handleOutputMessage);
        this.server.onStart(this.connect);
        this.server.onStop(this.handleServerStopped);
    }
    dispose() {
        var _a;
        (_a = this.wsClient) === null || _a === void 0 ? void 0 : _a.dispose();
        this._onMessage.dispose();
        this._onConnect.dispose();
        this._onActionCancelled.dispose();
        this._onGradleError.dispose();
        this._onGradleOutput.dispose();
        this._onGradleProgress.dispose();
    }
    getTasks(sourceDir) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.wsClient) {
                this.statusBarItem.text = '$(sync~spin) Gradle: Refreshing Tasks';
                this.statusBarItem.show();
                try {
                    const clientMessage = {
                        type: 'getTasks',
                        sourceDir
                    };
                    yield this.sendMessage(new Message(clientMessage));
                    const serverMessage = (yield this.waitForServerMessage('GRADLE_TASKS'));
                    return serverMessage.tasks;
                }
                catch (e) {
                    logger_1.logger.error(`Error providing gradle tasks: ${e.message}`);
                    throw e;
                }
                finally {
                    this.statusBarItem.hide();
                }
            }
        });
    }
    runTask(sourceDir, task, args, outputListener) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.wsClient) {
                const outputEvent = this.onGradleOutput(outputListener);
                this.statusBarItem.show();
                const clientMessage = {
                    type: 'runTask',
                    sourceDir,
                    task,
                    args
                };
                try {
                    yield this.sendMessage(new Message(clientMessage));
                    yield this.waitForServerMessage('GRADLE_RUN_TASK');
                }
                catch (e) {
                    logger_1.logger.error(`Error running task: ${e.message}`);
                    throw e;
                }
                finally {
                    this.statusBarItem.hide();
                    outputEvent.dispose();
                }
            }
        });
    }
    stopTask(sourceDir, task) {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.wsClient) {
                const clientMessage = {
                    type: 'stopTask',
                    sourceDir,
                    task
                };
                try {
                    yield this.sendMessage(new Message(clientMessage));
                }
                catch (e) {
                    logger_1.logger.error(`Error stopping task: ${e.message}`);
                }
                finally {
                    this.statusBarItem.hide();
                }
            }
        });
    }
    stopGetTasks(sourceDir = '') {
        return __awaiter(this, void 0, void 0, function* () {
            if (this.wsClient) {
                const clientMessage = {
                    type: 'stopGetTasks',
                    sourceDir
                };
                try {
                    yield this.sendMessage(new Message(clientMessage));
                }
                finally {
                    this.statusBarItem.hide();
                }
            }
        });
    }
    sendMessage(message) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                return yield new Promise((resolve, reject) => {
                    this.wsClient.send(message.toString(), (err) => {
                        if (err) {
                            reject(err);
                        }
                        else {
                            resolve();
                        }
                    });
                });
            }
            catch (e) {
                this.handleConnectionError();
                throw e;
            }
        });
    }
    handleConnectionError() {
        const READY_STATE_CLOSED = 3;
        if (this.wsClient.getInstance().readyState === READY_STATE_CLOSED) {
            this.server.showRestartMessage();
        }
    }
    waitForServerMessage(type) {
        return Promise.race([
            new Promise((_, reject) => {
                const event = this.server.onStop(() => {
                    reject(new Error('Error waiting for server message: The server stopped'));
                    event.dispose();
                });
            }),
            new Promise(resolve => {
                const event = this.onMessage((message) => {
                    if (message.type === type) {
                        resolve(message);
                        event.dispose();
                    }
                });
            })
        ]);
    }
}
exports.GradleTasksClient = GradleTasksClient;
function registerClient(server, statusBarItem, context) {
    const client = new GradleTasksClient(server, statusBarItem);
    context.subscriptions.push(client);
    client.onConnect(() => {
        vscode.commands.executeCommand('gradle.refresh', false);
    });
    client.onActionCancelled((message) => {
        tasks_1.handleCancelledTaskMessage(message);
    });
    return client;
}
exports.registerClient = registerClient;
//# sourceMappingURL=client.js.map