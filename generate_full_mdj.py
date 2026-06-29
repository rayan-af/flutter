
import os
import re
import json
import uuid

def gen_id():
    return "AAAAA" + str(uuid.uuid4()).replace("-", "")[:15]

def get_pkg_id(pkg_name, model_elements, M1_id):
    for el in model_elements:
        if el["_type"] == "UMLPackage" and el["name"] == pkg_name:
            return el["_id"]
    pid = gen_id()
    model_elements.append({
        "_type": "UMLPackage",
        "_id": pid,
        "_parent": {"$ref": M1_id},
        "name": pkg_name,
        "ownedElements": []
    })
    return pid

def run():
    mdj = {
        "_type": "Project",
        "_id": "P1",
        "name": "AdvFlutterFull",
        "ownedElements": [
            {
                "_type": "UMLModel",
                "_id": "M1",
                "_parent": {"$ref": "P1"},
                "name": "AppModel",
                "ownedElements": [
                    {
                        "_type": "UMLClassDiagram",
                        "_id": "D1",
                        "_parent": {"$ref": "M1"},
                        "name": "Full Class Diagram",
                        "defaultDiagram": True,
                        "ownedViews": []
                    }
                ]
            }
        ]
    }

    model_elements = mdj["ownedElements"][0]["ownedElements"]
    views = mdj["ownedElements"][0]["ownedElements"][0]["ownedViews"]

    class_re = re.compile(r"class\s+([A-Za-z0-9_]+)(?:\s+extends\s+([A-Za-z0-9_]+))?(?:\s+implements\s+([A-Za-z0-9_,\s]+))?\s*\{")
    
    classes_info = {}
    
    for root, dirs, files in os.walk("lib"):
        for file in files:
            if not file.endswith(".dart"): continue
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
            except:
                continue
            
            rel_path = os.path.relpath(root, "lib")
            pkg_name = "lib" if rel_path == "." else rel_path.replace(os.sep, ".")
            
            for match in class_re.finditer(content):
                cname = match.group(1)
                parent = match.group(2)
                
                cid = gen_id()
                classes_info[cname] = {
                    "id": cid,
                    "pkg": pkg_name,
                    "parent": parent,
                    "fields": []
                }

    x, y = 50, 50
    col_max_height = 0
    max_x = 2000
    width = 180
    height = 60
    
    for cname, info in classes_info.items():
        pkg_id = get_pkg_id(info["pkg"], model_elements, "M1")
        
        for el in model_elements:
            if el["_id"] == pkg_id:
                el["ownedElements"].append({
                    "_type": "UMLClass",
                    "_id": info["id"],
                    "_parent": {"$ref": pkg_id},
                    "name": cname
                })
                break
                
        info["x"] = x
        info["y"] = y
        view_id = info["id"] + "_view"
        views.append({
            "_type": "UMLClassView",
            "_id": view_id,
            "_parent": {"$ref": "D1"},
            "model": {"$ref": info["id"]},
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView",
                    "_id": info["id"] + "_name_comp",
                    "_parent": {"$ref": view_id},
                    "model": {"$ref": info["id"]},
                    "subViews": [
                        {
                            "_type": "LabelView",
                            "_id": info["id"] + "_stereo",
                            "_parent": {"$ref": info["id"] + "_name_comp"},
                            "visible": False, "left": 0, "top": 0, "width": 0, "height": 13
                        },
                        {
                            "_type": "LabelView",
                            "_id": info["id"] + "_name",
                            "_parent": {"$ref": info["id"] + "_name_comp"},
                            "font": "Arial;13;1",
                            "left": x+5, "top": y+10, "width": width-10, "height": 13,
                            "text": cname
                        },
                        {
                            "_type": "LabelView",
                            "_id": info["id"] + "_namespace",
                            "_parent": {"$ref": info["id"] + "_name_comp"},
                            "visible": False, "left": 0, "top": 0, "width": 0, "height": 13
                        }
                    ],
                    "font": "Arial;13;0", "left": x, "top": y, "width": width, "height": 30
                },
                {
                    "_type": "UMLAttributeCompartmentView",
                    "_id": info["id"] + "_attr_comp",
                    "_parent": {"$ref": view_id},
                    "model": {"$ref": info["id"]},
                    "font": "Arial;13;0", "left": x, "top": y+30, "width": width, "height": 10
                },
                {
                    "_type": "UMLOperationCompartmentView",
                    "_id": info["id"] + "_op_comp",
                    "_parent": {"$ref": view_id},
                    "model": {"$ref": info["id"]},
                    "font": "Arial;13;0", "left": x, "top": y+40, "width": width, "height": 10
                }
            ],
            "font": "Arial;13;0", "left": x, "top": y, "width": width, "height": height,
            "nameCompartment": {"$ref": info["id"] + "_name_comp"},
            "attributeCompartment": {"$ref": info["id"] + "_attr_comp"},
            "operationCompartment": {"$ref": info["id"] + "_op_comp"}
        })
        
        col_max_height = max(col_max_height, height)
        x += width + 50
        if x > max_x:
            x = 50
            y += col_max_height + 50
            col_max_height = 0

    for cname, info in classes_info.items():
        if info["parent"] and info["parent"] in classes_info:
            parent_info = classes_info[info["parent"]]
            gen_id_val = gen_id()
            
            for el in model_elements:
                if el["name"] == info["pkg"]:
                    for cls in el["ownedElements"]:
                        if cls["_id"] == info["id"]:
                            if "ownedElements" not in cls:
                                cls["ownedElements"] = []
                            cls["ownedElements"].append({
                                "_type": "UMLGeneralization",
                                "_id": gen_id_val,
                                "_parent": {"$ref": info["id"]},
                                "source": {"$ref": info["id"]},
                                "target": {"$ref": parent_info["id"]}
                            })
                            break
                    break
                    
            sx, sy = info["x"] + width//2, info["y"] + height//2
            tx, ty = parent_info["x"] + width//2, parent_info["y"] + height//2
            pts = str(sx)+":"+str(sy)+";"+str(tx)+":"+str(ty)

            views.append({
                "_type": "UMLGeneralizationView",
                "_id": gen_id_val + "_view",
                "_parent": {"$ref": "D1"},
                "model": {"$ref": gen_id_val},
                "head": {"$ref": parent_info["id"] + "_view"},
                "tail": {"$ref": info["id"] + "_view"},
                "lineStyle": 1,
                "points": pts,
                "font": "Arial;13;0",
                "nameLabel": {
                    "_type": "EdgeLabelView",
                    "_id": gen_id_val + "_name",
                    "_parent": {"$ref": gen_id_val + "_view"},
                    "model": {"$ref": gen_id_val},
                    "visible": False, "left": 0, "top": 0, "width": 0, "height": 13, "alpha": 1.57, "distance": 15, "hostEdge": {"$ref": gen_id_val + "_view"}, "edgePosition": 1
                },
                "stereotypeLabel": {
                    "_type": "EdgeLabelView",
                    "_id": gen_id_val + "_stereo",
                    "_parent": {"$ref": gen_id_val + "_view"},
                    "model": {"$ref": gen_id_val},
                    "visible": False, "left": 0, "top": 0, "width": 0, "height": 13, "alpha": 1.57, "distance": 30, "hostEdge": {"$ref": gen_id_val + "_view"}, "edgePosition": 1
                },
                "propertyLabel": {
                    "_type": "EdgeLabelView",
                    "_id": gen_id_val + "_prop",
                    "_parent": {"$ref": gen_id_val + "_view"},
                    "model": {"$ref": gen_id_val},
                    "visible": False, "left": 0, "top": 0, "width": 0, "height": 13, "alpha": -1.57, "distance": 15, "hostEdge": {"$ref": gen_id_val + "_view"}, "edgePosition": 1
                }
            })
            
    with open("full_app_diagram.mdj", "w", encoding="utf-8") as f:
        json.dump(mdj, f, indent=2)

if __name__ == "__main__":
    run()

