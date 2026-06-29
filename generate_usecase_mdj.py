
import json
import uuid

def gen_id():
    return "AAAAA" + str(uuid.uuid4()).replace("-", "")[:15]

def generate_usecases():
    mdj = {
      "_type": "Project",
      "_id": "P1",
      "name": "FullUseCaseDiagram",
      "ownedElements": [
        {
          "_type": "UMLModel",
          "_id": "M1",
          "_parent": { "$ref": "P1" },
          "name": "Model",
          "ownedElements": [
            {
              "_type": "UMLUseCaseDiagram",
              "_id": "D1",
              "_parent": { "$ref": "M1" },
              "name": "Comprehensive Use Case Diagram",
              "defaultDiagram": True,
              "ownedViews": []
            }
          ]
        }
      ]
    }
    
    diagram = mdj["ownedElements"][0]["ownedElements"][0]
    views = diagram["ownedViews"]
    model_elements = mdj["ownedElements"][0]["ownedElements"]
    
    def add_actor(name, left, top):
        aid = gen_id()
        vid = gen_id()
        comp_id = gen_id()
        model_elements.append({
            "_type": "UMLActor",
            "_id": aid,
            "_parent": { "$ref": "M1" },
            "name": name
        })
        views.append({
            "_type": "UMLActorView",
            "_id": vid,
            "_parent": { "$ref": "D1" },
            "model": { "$ref": aid },
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView",
                    "_id": comp_id,
                    "_parent": { "$ref": vid },
                    "model": { "$ref": aid },
                    "subViews": [
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "visible": False, "font": "Arial;13;0", "left": left, "top": top + 60, "width": 80, "height": 13
                        },
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "font": "Arial;13;1", "left": left, "top": top + 60, "width": 80, "height": 13,
                            "text": name, "wordWrap": True, "horizontalAlignment": 2
                        },
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "visible": False, "font": "Arial;13;0", "left": left, "top": top + 60, "width": 80, "height": 13,
                            "text": "(from Model)"
                        }
                    ],
                    "font": "Arial;13;0", "left": left, "top": top + 55, "width": 80, "height": 23
                }
            ],
            "font": "Arial;13;0", "left": left, "top": top, "width": 80, "height": 80,
            "nameCompartment": { "$ref": comp_id }
        })
        return aid, vid, left+40, top+40

    def add_usecase(name, left, top):
        uid = gen_id()
        vid = gen_id()
        comp_id = gen_id()
        model_elements.append({
            "_type": "UMLUseCase",
            "_id": uid,
            "_parent": { "$ref": "M1" },
            "name": name
        })
        
        w = 160
        h = 50
        
        views.append({
            "_type": "UMLUseCaseView",
            "_id": vid,
            "_parent": { "$ref": "D1" },
            "model": { "$ref": uid },
            "subViews": [
                {
                    "_type": "UMLNameCompartmentView",
                    "_id": comp_id,
                    "_parent": { "$ref": vid },
                    "model": { "$ref": uid },
                    "subViews": [
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "visible": False, "font": "Arial;13;0", "left": left, "top": top + 15, "width": w, "height": 13
                        },
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "font": "Arial;13;1", "left": left, "top": top + 15, "width": w, "height": 13,
                            "text": name, "wordWrap": True, "horizontalAlignment": 2
                        },
                        {
                            "_type": "LabelView", "_id": gen_id(),
                            "_parent": { "$ref": comp_id },
                            "visible": False, "font": "Arial;13;0", "left": left, "top": top + 15, "width": w, "height": 13,
                            "text": "(from Model)"
                        }
                    ],
                    "font": "Arial;13;0", "left": left, "top": top + 10, "width": w, "height": 23
                }
            ],
            "font": "Arial;13;0", "left": left, "top": top, "width": w, "height": h,
            "nameCompartment": { "$ref": comp_id }
        })
        return uid, vid, left+w//2, top+h//2

    def add_association(source_id, svid, target_id, tvid, sx, sy, tx, ty):
        asc_id = gen_id()
        model_elements.append({
            "_type": "UMLAssociation",
            "_id": asc_id,
            "_parent": { "$ref": "M1" },
            "end1": {
                "_type": "UMLAssociationEnd",
                "_id": gen_id(),
                "_parent": { "$ref": asc_id },
                "reference": { "$ref": source_id }
            },
            "end2": {
                "_type": "UMLAssociationEnd",
                "_id": gen_id(),
                "_parent": { "$ref": asc_id },
                "reference": { "$ref": target_id }
            }
        })
        views.append({
            "_type": "UMLAssociationView",
            "_id": asc_id + "_view",
            "_parent": { "$ref": "D1" },
            "model": { "$ref": asc_id },
            "head": { "$ref": tvid },
            "tail": { "$ref": svid },
            "lineStyle": 1,
            "points": str(sx) + ":" + str(sy) + ";" + str(tx) + ":" + str(ty),
            "font": "Arial;13;0"
        })
        
    def add_system_boundary(left, top, width, height, name):
        sid = gen_id()
        views.append({
            "_type": "UMLUseCaseSubjectView",
            "_id": sid,
            "_parent": { "$ref": "D1" },
            "model": { "$ref": "M1" },
            "subViews": [
                {
                    "_type": "LabelView",
                    "_id": gen_id(),
                    "_parent": { "$ref": sid },
                    "font": "Arial;13;1",
                    "left": left + 5,
                    "top": top + 5,
                    "width": width - 10,
                    "height": 13,
                    "text": name,
                    "horizontalAlignment": 2
                }
            ],
            "font": "Arial;13;0",
            "left": left,
            "top": top,
            "width": width,
            "height": height
        })

    add_system_boundary(300, 50, 320, 800, "AdvFlutter System")

    mgr_id, mgr_vid, mgr_x, mgr_y = add_actor("Manager", 100, 100)
    chef_id, chef_vid, chef_x, chef_y = add_actor("Chef", 100, 350)
    ai_id, ai_vid, ai_x, ai_y = add_actor("AI Service", 100, 600)
    
    staff_id, staff_vid, staff_x, staff_y = add_actor("Staff", 700, 150)
    cust_id, cust_vid, cust_x, cust_y = add_actor("Customer", 700, 400)
    fb_id, fb_vid, fb_x, fb_y = add_actor("Firebase Backend", 700, 650)
    
    uc_y = 80
    
    def next_uc(name):
        nonlocal uc_y
        uid, uvid, ux, uy = add_usecase(name, 380, uc_y)
        uc_y += 65
        return uid, uvid, ux, uy
        
    uc1_id, uc1_vid, uc1_x, uc1_y = next_uc("View Dashboard")
    uc2_id, uc2_vid, uc2_x, uc2_y = next_uc("Manage Inventory")
    uc3_id, uc3_vid, uc3_x, uc3_y = next_uc("Edit Menu & Dishes")
    uc4_id, uc4_vid, uc4_x, uc4_y = next_uc("Analyze Recipe Costing")
    uc5_id, uc5_vid, uc5_x, uc5_y = next_uc("Log Waste")
    uc6_id, uc6_vid, uc6_x, uc6_y = next_uc("View Orders")
    uc7_id, uc7_vid, uc7_x, uc7_y = next_uc("Process POS Orders")
    uc8_id, uc8_vid, uc8_x, uc8_y = next_uc("Manage Table Mapping")
    uc9_id, uc9_vid, uc9_x, uc9_y = next_uc("Make Reservation")
    uc10_id, uc10_vid, uc10_x, uc10_y = next_uc("Use AI Assistant")
    uc11_id, uc11_vid, uc11_x, uc11_y = next_uc("Authenticate")

    add_association(mgr_id, mgr_vid, uc1_id, uc1_vid, mgr_x, mgr_y, uc1_x, uc1_y)
    add_association(mgr_id, mgr_vid, uc2_id, uc2_vid, mgr_x, mgr_y, uc2_x, uc2_y)
    add_association(mgr_id, mgr_vid, uc3_id, uc3_vid, mgr_x, mgr_y, uc3_x, uc3_y)
    add_association(mgr_id, mgr_vid, uc4_id, uc4_vid, mgr_x, mgr_y, uc4_x, uc4_y)
    add_association(mgr_id, mgr_vid, uc5_id, uc5_vid, mgr_x, mgr_y, uc5_x, uc5_y)
    add_association(mgr_id, mgr_vid, uc10_id, uc10_vid, mgr_x, mgr_y, uc10_x, uc10_y)
    add_association(mgr_id, mgr_vid, uc11_id, uc11_vid, mgr_x, mgr_y, uc11_x, uc11_y)

    add_association(chef_id, chef_vid, uc6_id, uc6_vid, chef_x, chef_y, uc6_x, uc6_y)
    add_association(chef_id, chef_vid, uc5_id, uc5_vid, chef_x, chef_y, uc5_x, uc5_y)
    add_association(chef_id, chef_vid, uc11_id, uc11_vid, chef_x, chef_y, uc11_x, uc11_y)

    add_association(staff_id, staff_vid, uc7_id, uc7_vid, staff_x, staff_y, uc7_x, uc7_y)
    add_association(staff_id, staff_vid, uc8_id, uc8_vid, staff_x, staff_y, uc8_x, uc8_y)
    add_association(staff_id, staff_vid, uc9_id, uc9_vid, staff_x, staff_y, uc9_x, uc9_y)
    add_association(staff_id, staff_vid, uc11_id, uc11_vid, staff_x, staff_y, uc11_x, uc11_y)

    add_association(cust_id, cust_vid, uc9_id, uc9_vid, cust_x, cust_y, uc9_x, uc9_y)
    add_association(cust_id, cust_vid, uc11_id, uc11_vid, cust_x, cust_y, uc11_x, uc11_y)

    add_association(uc10_id, uc10_vid, ai_id, ai_vid, uc10_x, uc10_y, ai_x, ai_y)
    
    add_association(uc11_id, uc11_vid, fb_id, fb_vid, uc11_x, uc11_y, fb_x, fb_y)
    add_association(uc1_id, uc1_vid, fb_id, fb_vid, uc1_x, uc1_y, fb_x, fb_y) 
    add_association(uc6_id, uc6_vid, fb_id, fb_vid, uc6_x, uc6_y, fb_x, fb_y) 
    add_association(uc7_id, uc7_vid, fb_id, fb_vid, uc7_x, uc7_y, fb_x, fb_y) 

    with open("full_usecase_diagram.mdj", "w") as f:
        json.dump(mdj, f, indent=2)

if __name__ == "__main__":
    generate_usecases()

