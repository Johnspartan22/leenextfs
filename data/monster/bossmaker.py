import os
import re
import xml.etree.ElementTree as ET
from xml.dom import minidom

def add_script_to_original_monster(file_path):
    """Add the BossSystem script to the original monster file"""
    try:
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        # Check if script section already exists
        script_elem = root.find('script')
        if script_elem is None:
            # Add script section before voices
            voices_elem = root.find('voices')
            script_elem = ET.Element('script')
            event_elem = ET.SubElement(script_elem, 'event')
            event_elem.set('name', 'BossSystem')
            
            if voices_elem is not None:
                voices_index = list(root).index(voices_elem)
                root.insert(voices_index, script_elem)
            else:
                # If no voices section, add before loot
                loot_elem = root.find('loot')
                if loot_elem is not None:
                    loot_index = list(root).index(loot_elem)
                    root.insert(loot_index, script_elem)
                else:
                    # Add at the end if no loot section either
                    root.append(script_elem)
        
        # Format XML with proper indentation for saving
        rough_string = ET.tostring(root, 'utf-8')
        reparsed = minidom.parseString(rough_string)
        pretty_xml = reparsed.toprettyxml(indent="    ")
        
        # Clean up extra whitespace in output
        pretty_xml = re.sub(r'\n\s*\n', '\n', pretty_xml)
        
        # Add XML declaration
        xml_declaration = '<?xml version=\'1.0\' encoding=\'utf-8\'?>\n'
        
        # Save the modified original file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(xml_declaration + pretty_xml[pretty_xml.find('<monster'):])
        
        return f"Added BossSystem script to {file_path}"
    except Exception as e:
        return f"Error processing {file_path}: {str(e)}"

def generate_boss_file(original_file_path):
    """Generate a boss version of the original monster without adding the script section"""
    # Parse the original monster file
    tree = ET.parse(original_file_path)
    root = tree.getroot()
    
    # Get original monster name
    monster_name = root.get('name')
    boss_name = f"{monster_name} Boss"
    
    # Update monster attributes
    root.set('name', boss_name)
    
    # Double experience
    if 'experience' in root.attrib:
        original_exp = int(root.get('experience'))
        root.set('experience', str(original_exp * 2))
    
    # Set maglevel to 450 and speed to faster
    if 'maglevel' in root.attrib:
        root.set('maglevel', '450')
    
    if 'speed' in root.attrib:
        original_speed = int(root.get('speed'))
        root.set('speed', str(original_speed * 2))
    
    # Double health
    health_elem = root.find('health')
    if health_elem is not None:
        original_health = int(health_elem.get('now'))
        health_elem.set('now', str(original_health * 2))
        health_elem.set('max', str(original_health * 2))
    
    # Double attack values in attacks section
    attacks_elem = root.find('attacks')
    if attacks_elem is not None:
        for attack in attacks_elem.findall('attack'):
            if 'attack' in attack.attrib:
                original_attack = int(attack.get('attack'))
                attack.set('attack', str(original_attack * 2))
            if 'min' in attack.attrib and 'max' in attack.attrib:
                original_min = int(attack.get('min'))
                original_max = int(attack.get('max'))
                attack.set('min', str(original_min * 2))
                attack.set('max', str(original_max * 2))
    
    # Add flags section if not exists
    flags_elem = root.find('flags')
    if flags_elem is None:
        flags_elem = ET.SubElement(root, 'flags')
        
    # Make sure skull flag is present
    skull_flag_found = False
    for flag in flags_elem.findall('flag'):
        if 'skull' in flag.attrib:
            skull_flag_found = True
            flag.set('skull', '5')
            break
            
    if not skull_flag_found:
        skull_flag = ET.SubElement(flags_elem, 'flag')
        skull_flag.set('skull', '5')
    
    # Add boss event section
    events_elem = root.find('events')
    if events_elem is not None:
        root.remove(events_elem)
        
    events_elem = ET.Element('events')
    event = ET.SubElement(events_elem, 'event')
    
    # Convert monster name to lowercase and remove spaces for event name
    event_name = f"{monster_name.lower().replace(' ', '')}Boss"
    event.set('name', event_name)
    event.set('type', 'spawn')
    
    # Insert events element after flags
    root_list = list(root)
    flags_index = root_list.index(flags_elem) if flags_elem in root_list else 0
    root.insert(flags_index + 1, events_elem)
    
    # Remove script section if it exists - DO NOT ADD SCRIPT TO BOSS
    script_elem = root.find('script')
    if script_elem is not None:
        root.remove(script_elem)
    
    # Replace loot section with boss loot
    loot_elem = root.find('loot')
    if loot_elem is not None:
        root.remove(loot_elem)
    
    loot_elem = ET.Element('loot')
    item = ET.SubElement(loot_elem, 'item')
    item.set('id', '4313')
    item.set('chance', '150000')
    root.append(loot_elem)
    
    # Generate output filename
    file_name = os.path.basename(original_file_path)
    name_without_ext = os.path.splitext(file_name)[0]
    output_file = f"{name_without_ext}_boss.xml"
    
    # Format XML with proper indentation for saving
    rough_string = ET.tostring(root, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    pretty_xml = reparsed.toprettyxml(indent="    ")
    
    # Clean up extra whitespace in output
    pretty_xml = re.sub(r'\n\s*\n', '\n', pretty_xml)
    
    # Add XML declaration
    xml_declaration = '<?xml version=\'1.0\' encoding=\'utf-8\'?>\n'
    
    # Save to file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(xml_declaration + pretty_xml[pretty_xml.find('<monster'):])
    
    return output_file

def process_monster_files(directory='.'):
    """Process all monster XML files in the given directory"""
    results = []
    
    for file in os.listdir(directory):
        if file.endswith('.xml') and not file.endswith('_boss.xml'):
            file_path = os.path.join(directory, file)
            try:
                # Add script to original monster
                script_result = add_script_to_original_monster(file_path)
                results.append(script_result)
                
                # Generate boss file (without adding script to it)
                output_file = generate_boss_file(file_path)
                results.append(f"Created boss file: {output_file}")
            except Exception as e:
                results.append(f"Error processing {file}: {str(e)}")
    
    return results

# Example usage
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        try:
            # Add script to original monster
            script_result = add_script_to_original_monster(file_path)
            print(script_result)
            
            # Generate boss file (without adding script to it)
            output_file = generate_boss_file(file_path)
            print(f"Successfully created boss file: {output_file}")
        except Exception as e:
            print(f"Error: {str(e)}")
    else:
        print("Usage examples:")
        print("Process a single monster file:")
        print("python monster_processor.py monster.xml")
        print("\nOr run without arguments to process all XML files in current directory")
        print("python monster_processor.py")
        
        process_all = input("Do you want to process all monster XML files in the current directory? (y/n): ")
        if process_all.lower() == 'y':
            results = process_monster_files()
            for result in results:
                print(result)