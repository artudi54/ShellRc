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
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
const tasks_1 = require("./tasks");
const config_1 = require("./config");
const logger_1 = require("./logger");
const packageJson = JSON.parse(fs.readFileSync(path.join(__dirname, '../package.json')).toString());
function registerRunTaskCommand(treeDataProvider) {
    return vscode.commands.registerCommand('gradle.runTask', treeDataProvider.runTask, treeDataProvider);
}
function registerRunTaskWithArgsCommand(treeDataProvider) {
    return vscode.commands.registerCommand('gradle.runTaskWithArgs', treeDataProvider.runTaskWithArgs, treeDataProvider);
}
function registerStopTaskCommand(statusBarItem) {
    return vscode.commands.registerCommand('gradle.stopTask', task => {
        try {
            if (task && tasks_1.isTaskRunning(task)) {
                tasks_1.stopTask(task);
            }
        }
        catch (e) {
            logger_1.logger.error(`Unable to stop task: ${e.message}`);
        }
        finally {
            statusBarItem.hide();
        }
    });
}
function registerStopTreeItemTaskCommand() {
    return vscode.commands.registerCommand('gradle.stopTreeItemTask', treeItem => {
        if (treeItem && treeItem.task) {
            vscode.commands.executeCommand('gradle.stopTask', treeItem.task);
        }
    });
}
function registerRefreshCommand(taskProvider, treeDataProvider) {
    return vscode.commands.registerCommand('gradle.refresh', (forceDetection = true) => __awaiter(this, void 0, void 0, function* () {
        var _a;
        if (forceDetection) {
            tasks_1.enableTaskDetection();
        }
        const tasks = yield taskProvider.refresh();
        yield ((_a = treeDataProvider) === null || _a === void 0 ? void 0 : _a.refresh());
        if (config_1.getIsTasksExplorerEnabled()) {
            vscode.commands.executeCommand('setContext', 'gradle:showTasksExplorer', true);
        }
        return tasks;
    }));
}
function registerExplorerRenderCommand(treeDataProvider) {
    return vscode.commands.registerCommand('gradle.explorerRender', () => {
        treeDataProvider.render();
    });
}
function registerExplorerTreeCommand(treeDataProvider) {
    return vscode.commands.registerCommand('gradle.explorerTree', () => {
        treeDataProvider.setCollapsed(false);
    });
}
function registerExplorerFlatCommand(treeDataProvider) {
    return vscode.commands.registerCommand('gradle.explorerFlat', () => {
        treeDataProvider.setCollapsed(true);
    });
}
function registerKillGradleProcessCommand(client, statusBarItem) {
    return vscode.commands.registerCommand('gradle.killGradleProcess', () => {
        try {
            client.stopGetTasks();
            tasks_1.stopRunningGradleTasks();
            statusBarItem.hide();
        }
        catch (e) {
            logger_1.logger.error(`Unable to stop tasks: ${e.message}`);
        }
    });
}
function registerShowProcessMessageCommand() {
    return vscode.commands.registerCommand('gradle.showProcessMessage', () => __awaiter(this, void 0, void 0, function* () {
        var _a;
        const OPT_LOGS = 'View Logs';
        const OPT_CANCEL = 'Cancel Process';
        const input = yield vscode.window.showInformationMessage('Gradle Tasks Process', OPT_LOGS, OPT_CANCEL);
        if (input === OPT_LOGS) {
            (_a = logger_1.logger.getChannel()) === null || _a === void 0 ? void 0 : _a.show();
        }
        else if (input === OPT_CANCEL) {
            vscode.commands.executeCommand('gradle.killGradleProcess');
        }
    }));
}
function registerOpenSettingsCommand() {
    return vscode.commands.registerCommand('gradle.openSettings', () => {
        vscode.commands.executeCommand('workbench.action.openSettings', `@ext:${packageJson.publisher}.${packageJson.name}`);
    });
}
function registerOpenBuildFileCommand() {
    return vscode.commands.registerCommand('gradle.openBuildFile', (taskItem) => {
        vscode.commands.executeCommand('vscode.open', vscode.Uri.file(taskItem.task.definition.buildFile));
    });
}
function registerStoppingTreeItemTaskCommand() {
    return vscode.commands.registerCommand('gradle.stoppingTreeItemTask', () => {
        vscode.window.showInformationMessage(`Gradle task is shutting down`);
    });
}
function registerCommands(context, statusBarItem, client, treeDataProvider, taskProvider) {
    context.subscriptions.push(registerRunTaskCommand(treeDataProvider), registerRunTaskWithArgsCommand(treeDataProvider), registerStopTaskCommand(statusBarItem), registerStopTreeItemTaskCommand(), registerRefreshCommand(taskProvider, treeDataProvider), registerExplorerTreeCommand(treeDataProvider), registerExplorerFlatCommand(treeDataProvider), registerKillGradleProcessCommand(client, statusBarItem), registerShowProcessMessageCommand(), registerOpenSettingsCommand(), registerOpenBuildFileCommand(), registerStoppingTreeItemTaskCommand(), registerExplorerRenderCommand(treeDataProvider));
}
exports.registerCommands = registerCommands;
//# sourceMappingURL=commands.js.map