"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = __importStar(require("vscode"));
function getIsAutoDetectionEnabled(folder) {
    return (vscode.workspace
        .getConfiguration('gradle', folder.uri)
        .get('autoDetect', 'on') === 'on');
}
exports.getIsAutoDetectionEnabled = getIsAutoDetectionEnabled;
function getIsTasksExplorerEnabled() {
    return vscode.workspace
        .getConfiguration('gradle')
        .get('enableTasksExplorer', true);
}
exports.getIsTasksExplorerEnabled = getIsTasksExplorerEnabled;
function getIsDebugEnabled() {
    return vscode.workspace
        .getConfiguration('gradle')
        .get('debug', false);
}
exports.getIsDebugEnabled = getIsDebugEnabled;
//# sourceMappingURL=config.js.map