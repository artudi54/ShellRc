"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Logger {
    log(message, type) {
        if (!this.channel) {
            throw new Error('No extension output channel defined.');
        }
        this.channel.appendLine(`[${type}] ${message}`);
    }
    info(message) {
        this.log(message, 'info');
    }
    warning(message) {
        this.log(message, 'warning');
    }
    error(message) {
        this.log(message, 'error');
    }
    debug(message) {
        this.log(message, 'debug');
    }
    getChannel() {
        return this.channel;
    }
    setLoggingChannel(channel) {
        if (this.channel) {
            throw new Error('Output channel already defined.');
        }
        this.channel = channel;
    }
}
exports.Logger = Logger;
exports.logger = new Logger();
//# sourceMappingURL=logger.js.map