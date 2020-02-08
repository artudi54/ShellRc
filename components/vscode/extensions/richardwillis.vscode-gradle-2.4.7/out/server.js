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
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = __importStar(require("vscode"));
const get_port_1 = __importDefault(require("get-port"));
const logger_1 = require("./logger");
const tasks_1 = require("./tasks");
function isProcessRunning(pid) {
    try {
        process.kill(pid, 0);
        return true;
    }
    catch (error) {
        return error.code === 'EPERM';
    }
}
class GradleTasksServer {
    constructor(opts, context) {
        this.opts = opts;
        this.context = context;
        this._onStart = new vscode.EventEmitter();
        this._onStop = new vscode.EventEmitter();
        this.onStart = this._onStart.event;
        this.onStop = this._onStop.event;
        this.taskName = 'Gradle Server';
        context.subscriptions.push(vscode.tasks.onDidStartTaskProcess(event => {
            if (event.execution.task.name === this.taskName && event.processId) {
                if (isProcessRunning(event.processId)) {
                    logger_1.logger.info('Gradle server started');
                    this._onStart.fire();
                }
                else {
                    logger_1.logger.error('Error starting gradle server');
                }
            }
        }), vscode.tasks.onDidEndTaskProcess(event => {
            if (event.execution.task.name === this.taskName) {
                logger_1.logger.info(`Gradle server stopped`);
                this._onStop.fire();
                this.showRestartMessage();
            }
        }));
    }
    start() {
        return __awaiter(this, void 0, void 0, function* () {
            this.port = yield get_port_1.default();
            const cwd = this.context.asAbsolutePath('lib');
            const task = tasks_1.buildGradleServerTask(this.taskName, cwd, [String(this.port)]);
            this.taskExecution = yield vscode.tasks.executeTask(task);
        });
    }
    showRestartMessage() {
        return __awaiter(this, void 0, void 0, function* () {
            const OPT_RESTART = 'Restart Server';
            const input = yield vscode.window.showErrorMessage('No connection to gradle server. Try restarting the server.', OPT_RESTART);
            if (input === OPT_RESTART) {
                this.start();
            }
        });
    }
    dispose() {
        var _a;
        (_a = this.taskExecution) === null || _a === void 0 ? void 0 : _a.terminate();
        this._onStart.dispose();
    }
    getPort() {
        return this.port;
    }
    getOpts() {
        return this.opts;
    }
}
exports.GradleTasksServer = GradleTasksServer;
function registerServer(opts, context) {
    const server = new GradleTasksServer(opts, context);
    context.subscriptions.push(server);
    server.start();
    return server;
}
exports.registerServer = registerServer;
//# sourceMappingURL=server.js.map