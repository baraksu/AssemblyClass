# Open the input and output files
with open(r"C:\Users\bsuberri\OneDrive - NI\Documents\teacher\assebmly\MySources\Gamliel\Targil04.asm", 'r') as infile, open(r"C:\Users\bsuberri\OneDrive - NI\Documents\teacher\assebmly\MySources\Gamliel\Targil04_t.asm", 'w') as outfile:
    # Read each line from the input file
    for line in infile:
        # Write the line to the output file
        new_line = line
        if not line.startswith (';') or not line.startswith("."):
            new_line = line[:-3] + '\n'
            
               
        outfile.write(new_line)
