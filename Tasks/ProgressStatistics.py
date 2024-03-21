# Open the input and output files
with open(r'C:\Users\bsuberri\Documents\teacher\Tasks\Progress.txt', 'r',encoding="utf8") as infile, open(r'C:\Users\bsuberri\Documents\teacher\Tasks\Progress1.txt', 'w',encoding="utf8") as outfile:
    # Read each line from the input file
    outfile.write('HEAD, Name \n') 
    for line in infile:
        # Write the line to the output file
        start = line.find("(") 
        end = line.find(")")
        split = line.find('/')

        endName =line.find('  ')

        if start > 0 and end > 0:
            start +=1
            new_line = line[start:split] + ','+  line[:endName].strip()
            outfile.write(new_line + '\n')
        

    