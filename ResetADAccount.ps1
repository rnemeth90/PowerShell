$UFN=READ-HOST ‘Please type in the users first name: ’ 
$ULN=READ-HOST ‘Please type in the users last Name: ’ 
GET-QADUSER –FirstName $UFN –LastName $ULN | UNLOCK-QADUSER