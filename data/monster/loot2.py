import os
import xml.etree.ElementTree as ET

def clean_monster_loot(directory_path, items_to_remove):
    """
    Process all XML files in the given directory and remove specified item IDs from monster loot lists.
    
    Args:
        directory_path (str): Path to directory containing monster XML files
        items_to_remove (list): List of item IDs to remove from loot tables
    """
    # Convert items to remove to strings since XML attributes are strings
    items_to_remove = [str(item) for item in items_to_remove]
    
    # Track statistics
    total_files = 0
    processed_files = 0
    files_with_changes = 0
    files_with_loot = 0
    total_items_removed = 0
    
    # Process each XML file in the directory
    for filename in os.listdir(directory_path):
        if filename.endswith('.xml'):
            total_files += 1
            file_path = os.path.join(directory_path, filename)
            try:
                # Parse the XML file
                tree = ET.parse(file_path)
                root = tree.getroot()
                processed_files += 1
                
                # Find the loot section - handle different potential structures
                loot_section = root.find('loot')
                
                if loot_section is not None:
                    files_with_loot += 1
                    
                    # Keep track of items to remove
                    items_to_delete = []
                    
                    # Check each item in the loot section
                    for item in loot_section.findall('item'):
                        # The items in Tibia 7.6 XML format use "id" attribute
                        item_id = item.get('id')
                        
                        # If we found an id, check if it's in our removal list
                        if item_id in items_to_remove:
                            items_to_delete.append(item)
                    
                    # Remove the identified items
                    for item in items_to_delete:
                        loot_section.remove(item)
                        total_items_removed += 1
                    
                    # Only save if we made changes
                    if items_to_delete:
                        files_with_changes += 1
                        print(f"Removing {len(items_to_delete)} items from {filename}")
                        tree.write(file_path, encoding='utf-8', xml_declaration=True)
                    else:
                        print(f"No matching items found in {filename}")
                else:
                    print(f"No loot section found in {filename}")
                        
            except ET.ParseError as e:
                print(f"Error parsing {filename}: {e}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")
    
    # Print summary statistics
    print(f"\nSummary:")
    print(f"Total XML files found: {total_files}")
    print(f"Files successfully processed: {processed_files}")
    print(f"Files with loot sections: {files_with_loot}")
    print(f"Files with items removed: {files_with_changes}")
    print(f"Total items removed: {total_items_removed}")
    print(f"Files with no loot section: {processed_files - files_with_loot}")
    print(f"Files with parsing errors: {total_files - processed_files}")

def main():
    # List of item IDs to remove
    items_to_remove = [
        5014, 2331, 2298, 2403, 4336, 2495, 2493, 2494, 2520, 2357, 3940,
        4352, 4390, 4389, 4367, 2483, 4992, 4337, 4338, 4339, 4340, 4341, 2151,
        4366, 2176, 2174, 2177, 2178, 2179, 2180, 2129, 2127, 2126, 2125, 2124,
        2122, 2329, 4342, 4343, 4344, 4345, 4346, 5088
    ]
    
    # Directory path - can be updated or made into a command line argument
    directory_path = r"C:\Users\Simon\Desktop\111UNDERWORLD111\underworld_live_3_13_25 (2)\underworld_live_3_10_25\underworld_live_3_6_25\7.72\data\monster"
    
    # Verify the directory exists
    if not os.path.isdir(directory_path):
        print("Error: Invalid directory path")
        return
    
    # Process the files
    print(f"Processing XML files in {directory_path}")
    clean_monster_loot(directory_path, items_to_remove)
    
    # Ask if user wants to see their items list
    print("\nItems that were removed from loot tables:")
    for item_id in items_to_remove:
        print(f"- Item ID: {item_id}")
    
    print("\nProcessing complete!")

if __name__ == "__main__":
    main()