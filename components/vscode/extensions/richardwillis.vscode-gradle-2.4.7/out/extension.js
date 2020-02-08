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
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = __importStar(require("vscode"));
const gradleView_1 = require("./gradleView");
const tasks_1 = require("./tasks");
const server_1 = require("./server");
const client_1 = require("./client");
const commands_1 = require("./commands");
const logger_1 = require("./logger");
function activate(context) {
    return __awaiter(this, void 0, void 0, function* () {
        const statusBarItem = vscode.window.createStatusBarItem();
        statusBarItem.command = 'gradle.showProcessMessage';
        logger_1.logger.setLoggingChannel(vscode.window.createOutputChannel('Gradle Tasks'));
        const server = server_1.registerServer({ host: 'localhost' }, context);
        const client = client_1.registerClient(server, statusBarItem, context);
        const taskProvider = tasks_1.registerTaskProvider(context, client);
        const treeDataProvider = gradleView_1.registerExplorer(context, client);
        commands_1.registerCommands(context, statusBarItem, client, treeDataProvider, taskProvider);
        return { treeDataProvider, context, client, logger: logger_1.logger };
    });
}
exports.activate = activate;
// eslint-disable-next-line @typescript-eslint/no-empty-function
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map