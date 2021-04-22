#!/usr/bin/env python3

import argparse, json, sys
import xml.etree.ElementTree as ET

def debug_print(message):
    if args.verbose:
        print(message, file=sys.stderr)

def print_yaml_front_matter(the_dict):
    print('---')
    for key, value in the_dict.items():
        print(f'{key}: {value}')
    print('---')
    print()

def fix_iso_date(the_datetime):
    '''Change T seperator to a space, and remove UTC marker, and assume UTC '''
    return the_datetime.replace('T', ' ', 1).replace('Z', '', 1)

xmlns = dict(
    cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties",
    dc="http://purl.org/dc/elements/1.1/",
    dcterms="http://purl.org/dc/terms/",	
    dcmitype="http://purl.org/dc/dcmitype/",
    xsi="http://www.w3.org/2001/XMLSchema-instance")
    
def tag_name(full_tag_name):
    prefix, name = full_tag_name.split(':', 2)
    namespace = xmlns[prefix]
    return '{'+namespace+'}'+name

mapping = { tag_name('dc:title'): 'title',
            tag_name('dc:subject'): None,
            tag_name('dc:creator'): 'author',
            tag_name('dc:description'): None,
            tag_name('cp:keywords'): 'tags',
            tag_name('cp:lastModifiedBy'): None,
            tag_name('cp:revision'): None,
            tag_name('cp:category'): 'categories',
            tag_name('dcterms:created'): 'date',
            tag_name('dcterms:modified'): 'changed'}

convert = dict(date=fix_iso_date, changed=fix_iso_date)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert Word meta-data XML (from stdin) to YAML Front Matter (to stdout)')
    parser.add_argument('--verbose', '-v', action='store_true', default=False, help='show more information (to stderr)')
    args = parser.parse_args()

    result = {}
    root = ET.fromstring(sys.stdin.read())
    if root.tag == tag_name('cp:coreProperties'):
        for child in root:
            if child.tag in mapping:
                mapped_to = mapping[child.tag]
                if mapped_to:
                    if child.text:
                        the_text = child.text
                        if mapped_to in convert:
                            the_text = convert[mapped_to](the_text)
                        if mapped_to in result:
                            result[mapped_to] += ", " + the_text
                        else:
                            result[mapped_to] = the_text
                    else:
                        debug_print(f"Skipping '{child.tag}' because empty")
                else:
                    debug_print(f"Skipping '{child.tag}' (mapped to None)")
            else:
                debug_print(f"Ignoring '{child.tag}' (not in mapping)")
    else:
        debug_print("Unrecognized XML document")
        exit(1)
    print_yaml_front_matter(result)
    #print(json.dumps(result, indent=4))

