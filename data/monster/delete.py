import os
import sys

def delete_boss_files(directory='.', dry_run=True):
    """
    Delete all boss monster files (ending with _boss.xml) in the specified directory
    
    Parameters:
    directory (str): Directory to scan for boss files
    dry_run (bool): If True, only show what would be deleted without actually deleting
    
    Returns:
    list: List of deleted files
    """
    deleted_files = []
    
    # Get all files in the directory
    try:
        all_files = os.listdir(directory)
    except Exception as e:
        print(f"Error accessing directory {directory}: {e}")
        return deleted_files
    
    # Find boss files
    boss_files = [file for file in all_files if file.endswith('_boss.xml')]
    
    if not boss_files:
        print("No boss monster files found.")
        return deleted_files
    
    # Process the files
    for file in boss_files:
        file_path = os.path.join(directory, file)
        
        if dry_run:
            print(f"Would delete: {file}")
            deleted_files.append(file)
        else:
            try:
                os.remove(file_path)
                print(f"Deleted: {file}")
                deleted_files.append(file)
            except Exception as e:
                print(f"Failed to delete {file}: {e}")
    
    return deleted_files

if __name__ == "__main__":
    directory = '.'
    dry_run = True  # Default to dry run for safety
    
    # Process command line arguments
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    
    # Show initial message
    print("Boss Monster File Deletion Tool")
    print("===============================")
    print(f"Scanning directory: {directory}")
    
    # First do a dry run to show what would be deleted
    files = delete_boss_files(directory, dry_run=True)
    
    if files:
        print(f"\nFound {len(files)} boss monster files to delete")
        confirmation = input("\nAre you sure you want to delete these files? (yes/no): ")
        
        if confirmation.lower() in ['yes', 'y']:
            # Do the actual deletion
            deleted = delete_boss_files(directory, dry_run=False)
            print(f"\nSuccessfully deleted {len(deleted)} boss monster files")
        else:
            print("\nDeletion cancelled")
    else:
        print("No files to delete")
