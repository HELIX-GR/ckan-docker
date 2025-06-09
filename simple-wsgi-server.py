#!/usr/bin/env python

import sys
import importlib
from wsgiref.simple_server import make_server

def main():
    if len(sys.argv) != 2:
        print("Usage: python simple-wsgi-server.py <module>:<callable>")
        sys.exit(1)
    app_path = sys.argv[1] # e.g., "application:application"

    try:
        module_name, callable_name = app_path.split(':', 1)
    except ValueError:
        print("Error: Argument must be in the format 'module:callable'")
        sys.exit(1)

    # Dynamically import the module and get the callable
    try:
        module = importlib.import_module(module_name)
        application_callable = getattr(module, callable_name)
    except ModuleNotFoundError:
        print(f"Error: Module '{module_name}' not found.")
        sys.exit(1)
    except AttributeError:
        print(f"Error: Callable '{callable_name}' not found in module '{module_name}'.")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during import: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)

    host = '0.0.0.0'
    port = 5000

    print(f"Starting simple WSGI server on http://{host}:{port}/")
    print(f"Serving application: {app_path}")
    print("Press Ctrl+C to exit.")

    try:
        # Create a WSGI server with the dynamically loaded callable
        httpd = make_server(host, port, application_callable)
        # Serve until process is killed
        httpd.serve_forever()
    except Exception as e:
        print(f"\nError during server startup: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nServer shutting down gracefully...", file=sys.stderr)
        sys.exit(0)

if __name__ == '__main__':
    main()
