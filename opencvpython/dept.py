import cv2
import cvzone
from cvzone.FaceMeshModule import FaceMeshDetector

cap = cv2.VideoCapture('video/5.mp4')
detector = FaceMeshDetector(maxFaces=1)

def action():
    success, img = cap.read()
    img, faces = detector.findFaceMesh(img)

    if faces:
        face = faces[0]
        pointLeft = face[145]
        pointRight = face[374]
        cv2.circle(img, pointLeft, 5, (225,0,225),cv2.FILLED)
        cv2.circle(img, pointRight, 5, (225,0,225),cv2.FILLED)
        cv2.line(img, pointLeft, pointRight,(0,224,0),3)
        w,_ = detector.findDistance(pointLeft,pointRight)
        cvzone.putTextRect(img, str(w) ,(face[10][0],face[10][1]))
        cv2.imshow('output',img)
        cv2.waitKey(1)

        return w
        
def ratio():
    pixel = action()
    if pixel != None:
        ratioMMperMatrix = 64/pixel
        return ratioMMperMatrix
    else:
        return 1

while True:
    action()
    act = action()
    print(act)
