FasdUAS 1.101.10   ��   ��    k             j     �� �� 0 blog_appkey    m         iy      	 
 	 j    �� �� 0 blog_id    m    ����  
     j    �� �� 0 	blog_user    m       
 isao         j   	 �� �� 0 	blog_pass    m   	 
    future         j    �� �� 0 blog_publish    m    ��
�� boovtrue      j    �� �� 0 blog_postid    m                  l     ������  ��        i         I     �� !��
�� .aevtoappnull  �   � **** ! J      ����  ��     k      " "  # $ # O     % & % e     ' ' l    (�� ( n     ) * ) 1   
 ��
�� 
pcnt * n    
 + , + 1    
��
�� 
pusl , 4    �� -
�� 
TxtW - m    ���� ��   & m      . .�null     �����   
BBEdit.app�͐ascr�b� � `���Ͱ    y`    )       ��(�aو���� zR*ch   alis    :  foobar                     ���BH+     
BBEdit.app                                                      U)x��d�        ����  	                Applications    ��!�      ���E         foobar:Applications:BBEdit.app   
 B B E d i t . a p p    f o o b a r  Applications/BBEdit.app   / ��   $  /�� / I    �� 0���� 0 main   0  1�� 1 1    ��
�� 
rslt��  ��  ��     2 3 2 l     ������  ��   3  4 5 4 i     6 7 6 I      �� 8���� 0 main   8  9�� 9 o      ���� 0 s  ��  ��   7 l    > : ; : Q     > < = > < Z    ' ? @�� A ? =     B C B o    ���� 0 s   C m     D D       @ R   	 �� E��
�� .ascrerr ****      � **** E m     F F  no text selected   ��  ��   A k    ' G G  H I H r     J K J I    �� L���� 0 post   L  M�� M o    ���� 0 s  ��  ��   K o      ���� 0 blog_postid   I  N�� N I    '�� O���� 
0 review   O  P�� P o    #���� 0 blog_postid  ��  ��  ��   = R      �� Q��
�� .ascrerr ****      � **** Q o      ���� 0 msg  ��   > I  / >�� R S
�� .sysodlogaskr        TEXT R b   / 2 T U T m   / 0 V V  error:     U o   0 1���� 0 msg   S �� W X
�� 
btns W J   3 6 Y Y  Z�� Z m   3 4 [ [  Cancel   ��   X �� \ ]
�� 
dflt \ m   7 8����  ] �� ^��
�� 
disp ^ m   9 :���� ��   ; ' ! BigCat passes selected text here    5  _ ` _ l     ������  ��   `  a b a i     c d c I      �� e���� 0 post   e  f�� f o      ���� 0 s  ��  ��   d O     + g h g L    * i i I   )�� j��
�� .rpc RPC2list���    reco j K    % k k �� l m
�� 
meth l m     n n  blogger.newPost    m �� o��
�� 
parm o J    # p p  q r q o    ���� 0 blog_appkey   r  s t s o    ���� 0 blog_id   t  u v u o    ���� 0 	blog_user   v  w x w o    ���� 0 	blog_pass   x  y z y o    ���� 0 s   z  {�� { o    !���� 0 blog_publish  ��  ��  ��   h m      | | �null     ߀-a Safaridoc   open location not working ?!����mv   Oopen OL *  BAD*@  aprlhttp://wiki.mediabolic.com/xmlrpc.php b  } ~ } l     ������  ��   ~   �  i    ! � � � I      �� ����� 0 edit   �  ��� � o      ���� 0 s  ��  ��   � O     0 � � � L    / � � I   .�� ���
�� .rpc RPC2list���    reco � K    * � � �� � �
�� 
meth � m     � �  blogger.editPost    � �� ���
�� 
parm � J    ( � �  � � � o    ���� 0 blog_appkey   �  � � � o    ���� 0 blog_postid   �  � � � o    ���� 0 blog_id   �  � � � o    ���� 0 	blog_user   �  � � � o     ���� 0 	blog_pass   �  � � � o     !���� 0 s   �  ��� � o   ! &���� 0 blog_publish  ��  ��  ��   � m      | �  � � � l     ������  ��   �  � � � i   " % � � � I      �� ����� 
0 review   �  ��� � o      ���� 0 n  ��  ��   � k     " � �  � � � I    �� � �
�� .sysodlogaskr        TEXT � m      � � ( "Posted to Tiki. Review in browser?    � �� � �
�� 
btns � J     � �  � � � m     � �  no    �  ��� � m     � � 	 yes   ��   � �� � �
�� 
dflt � m    ����  � �� ���
�� 
disp � m   	 
���� ��   �  ��� � Z    " � ����� � =    � � � n     � � � 1    ��
�� 
bhit � 1    ��
�� 
rslt � m     � � 	 yes    � I   �� ���
�� .GURLGURLnull    ��� TEXT � b     � � � m     � � I Chttp://wiki.mediabolic.com/tiki-view_blog_post.php?blogId=1&postId=    � o    ���� 0 n  ��  ��  ��  ��   �  � � � l     ������  ��   �  ��� � l      �� ���   ���

blogger.newPost makes a new post to a designated blog. Optionally, will publish the blog after making the post. On success, it returns the unique ID of the new post (usually a seven-digit number at this time). On error, it will return some error message. blogger.newPost takes the following parameters. All are required:

 1. appkey (string): Unique identifier/passcode of the application
  	sending the post. (See access info.)
 2. blogid (string): Unique identifier of the blog the post will be
  	added to.
 3. username (string): Login for a Blogger user who has permission to
  	post to the blog.
 4. password (string): Password for said username.
 5. content (string): Contents of the post.
 6. publish (boolean): If true, the blog will be published immediately
  	after the post is made.

 http://www.blogger.com/developers/api/1_docs/xmlrpc_newPost.html


blogger.editPost changes the contents of a given post. Optionally, will publish the blog the post belongs to after changing the post. On success, it returns a boolean true value. On error, it will return a fault with an error message. blogger.editPost takes the following parameters. All are required:

 1. appkey (string): Unique identifier/passcode of the application
  	sending the post. (See access info.)
 2. postid (string): Unique identifier of the post to be changed.
 3. username (string): Login for a Blogger user who has permission to
  	edit the given post (either the user who originally created it or an
  	admin of the blog).
 4. password (string): Password for said username.
 5. content (string): New content of the post.
 6. publish (boolean): If true, the blog will be published immediately
  	after the post is made.

 http://www.blogger.com/developers/api/1_docs/xmlrpc_editPost.html

   ��       �� � ��  ��  � � � � ���   � ��������������~�}�|�{�� 0 blog_appkey  �� 0 blog_id  �� 0 	blog_user  �� 0 	blog_pass  �� 0 blog_publish  �� 0 blog_postid  
� .aevtoappnull  �   � ****�~ 0 main  �} 0 post  �| 0 edit  �{ 
0 review  �� 
�� boovtrue � �z  �y�x � ��w
�z .aevtoappnull  �   � ****�y  �x   �   �  .�v�u�t�s�r
�v 
TxtW
�u 
pusl
�t 
pcnt
�s 
rslt�r 0 main  �w � *�k/�,�,EUO*�k+  � �q 7�p�o � ��n�q 0 main  �p �m ��m  �  �l�l 0 s  �o   � �k�j�k 0 s  �j 0 msg   �  D F�i�h�g�f V�e [�d�c�b�a�i 0 post  �h 
0 review  �g 0 msg  �f  
�e 
btns
�d 
dflt
�c 
disp�b 
�a .sysodlogaskr        TEXT�n ? )��  	)j�Y *�k+ Ec  O*b  k+ W X  �%��kv�k�l�  � �` d�_�^ � ��]�` 0 post  �_ �\ ��\  �  �[�[ 0 s  �^   � �Z�Z 0 s   �  |�Y n�X�W�V�U
�Y 
meth
�X 
parm�W �V 
�U .rpc RPC2list���    reco�] ,� (���b   b  b  b  �b  �v�j U � �T ��S�R � ��Q�T 0 edit  �S �P ��P  �  �O�O 0 s  �R   � �N�N 0 s   �  |�M ��L�K�J�I
�M 
meth
�L 
parm�K �J 
�I .rpc RPC2list���    reco�Q 1� -���b   b  b  b  b  �b  �v�j U � �H ��G�F � ��E�H 
0 review  �G �D ��D  �  �C�C 0 n  �F   � �B�B 0 n   �  ��A � ��@�?�>�=�<�; � ��:
�A 
btns
�@ 
dflt
�? 
disp�> 
�= .sysodlogaskr        TEXT
�< 
rslt
�; 
bhit
�: .GURLGURLnull    ��� TEXT�E #����lv�l�k� O��,�  �%j Y hascr  ��ޭ