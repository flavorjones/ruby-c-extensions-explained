This is intended to be an explanatory repository demonstrating a few different strategies for building C extensions.

Broadly categorized, the strategies are:

Strategy 0: A self-contained C extension (no external libraries)
Strategy 1: Find and use an external library already installed on the target system
Strategy 2: Package your own source code for the external library, and compile during installation
Stragegy 3: Precompile the library ahead-of-time and package the shared libraries

These strategies can also be combined, which this repository also demonstrates.
