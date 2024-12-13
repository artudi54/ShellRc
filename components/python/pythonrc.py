import os
import readline
import atexit

HISTORY_FILE = os.path.join(os.getenv("SHELLRC_STATE_DIR"), "python_history.log")


def load_history():
    try:
        readline.read_history_file(HISTORY_FILE)
    except IOError:
        pass


def save_history():
    try:
        readline.write_history_file(HISTORY_FILE)
    except IOError:
        pass

load_history()
atexit.register(save_history)

