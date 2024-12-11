import cv2

img = cv2.imread('jihyoo.jpg')
# cap = cv2.VideoCapture(1)
# cap.set(3,640)
# cap.set(4,480)


classNames = []
classFile = 'coco.names'
with open(classFile,'rt') as f:
	classNames = f.read().rstrip('\n').rsplit('\n')

configPath = 'ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt'
weightsPath ='frozen_inference_graph.pb'

net = cv2.dnn_DetectionModel(weightsPath, configPath)
net.setInputSize(320, 320)
net.setInputScale(1.0/ 127.5)
net.setInputMean((127.5, 127.5, 127.5))
net.setInputSwapRB(True)

# while True:
# 	success, img = cap.read()
classIds, confs, bbox = net.detect(img, confThreshold=0.5)
print(classIds, bbox)

if len(classIds) != 0:
	for classId, cofidence, box in zip(classIds.flatten(),confs.flatten(), bbox):
		cv2.rectangle(img,box,color=(0,225,0,),thickness=2)
		
		lebar = abs(int(box[0])-int(box[2]))
		tinggi = abs(int(box[1])-int(box[3]))
		namaBenda = classNames[classId-1]
		
		cv2.putText(img, str(namaBenda) , (box[0]+10,box[1]+30),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,225,0),2)
		cv2.putText(img, "lebar: " + str(lebar) + " mm" , (box[0]+10,box[1]+50),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,225,0),2)
		cv2.putText(img, "tinggi: " + str(tinggi) + " mm" , (box[0]+10,box[1]+70),cv2.FONT_HERSHEY_COMPLEX,0.5,(0,225,0),2)

cv2.imshow("OUTPUT", img)

cv2.waitKey(0)