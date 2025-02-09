### Actually Additions Coffee Scripts

**Demo:** https://www.reddit.com/r/feedthebeast/comments/tp9oew/fully_automated_beefueled_coffee_machine_i_made/

The follow scripts work with ComputerCraft.

The primary script requires a **minimum 2x3 vertical display** and a the secondary (optional) script requires a 3x2 horizontal display

Rear output wires are expected to send one stack of items of their respective ingredient to the coffee machine.

Ingredients correspond to a the color of output that shares their index in the "wire" map.

If required for buffering, a white output is transmitted from the front of the machine after each ingredient is signalled.

Starting the coffee machine is mapped to a red output from the front of the computer, and block destruction of the machine is mapped to a green output from the start of the computer.
