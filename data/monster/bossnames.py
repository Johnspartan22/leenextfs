import os

def list_boss_filenames(directory='.', output_file='boss_list.txt'):
    """
    Creates a simple list of boss monster filenames in the specified format
    """
    # Find all boss monster files
    boss_files = []
    for file in os.listdir(directory):
        if file.endswith('_boss.xml'):
            boss_files.append(file)
    
    # Sort the list alphabetically
    boss_files.sort()
    
    # Write to output file
    with open(output_file, 'w') as f:
        for file in boss_files:
            f.write(f"{file}\n")
    
    return output_file, boss_files

if __name__ == "__main__":
    import sys
    
    directory = '.'
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    
    output_file, boss_files = list_boss_filenames(directory)
    
    print(f"Found {len(boss_files)} boss files:")
    for file in boss_files:
        print(file)
    
    print(f"\nList saved to {output_file}")