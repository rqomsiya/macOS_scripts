FasdUAS 1.101.10   ��   ��    k             j     �� �� 0 thetitle theTitle  m        � 	 	 B U s e r   M i g r a t i o n   T o o l   f o r   M a c   v 0 . 0 1   
  
 l     ��������  ��  ��        l     ����  r         I    ��  
�� .sysodlogaskr        TEXT  m        �   d D o   y o u   w a n t   t o   B A C K U P   o r   R E S T O R E   a   u s e r ' s   p r o f i l e ?  ��  
�� 
appr  o    ���� 0 thetitle theTitle  �� ��
�� 
btns  J           m    	   �    B a c k u p      m   	 
   �      R e s t o r e   !�� ! m   
  " " � # #  C a n c e l��  ��    o      ���� $0 thedialogresults theDialogResults��  ��     $ % $ l   ) &���� & Z    ) ' (�� ) ' =    * + * n     , - , 1    ��
�� 
bhit - o    ���� $0 thedialogresults theDialogResults + m     . . � / /  B a c k u p ( I    !�������� 
0 backup  ��  ��  ��   ) I   $ )�������� 0 restore  ��  ��  ��  ��   %  0 1 0 l     ��������  ��  ��   1  2 3 2 i     4 5 4 I      �������� 
0 backup  ��  ��   5 k     � 6 6  7 8 7 l     �� 9 :��   9 2 ,  get the path to the user folder to backup     : � ; ; X     g e t   t h e   p a t h   t o   t h e   u s e r   f o l d e r   t o   b a c k u p   8  < = < r      > ? > I    ���� @
�� .sysostflalis    ��� null��   @ �� A B
�� 
prmp A m     C C � D D ^ S e l e c t   a   u s e r   f o l d e r   t o   b a c k u p   t o   a   d i s k   i m a g e . B �� E��
�� 
dflc E I   	�� F��
�� .earsffdralis        afdr F m    ��
�� afdrusrs��  ��   ? o      ���� 0 	thesource 	theSource =  G H G l   ��������  ��  ��   H  I J I l   �� K L��   K 8 2  get file name and path where image will be saved    L � M M d     g e t   f i l e   n a m e   a n d   p a t h   w h e r e   i m a g e   w i l l   b e   s a v e d J  N O N r    ! P Q P I   ���� R
�� .sysonwflfile    ��� null��   R �� S T
�� 
prmt S m     U U � V V � S e l e c t   t h e   n a m e   a n d   l o c a t i o n   w h e r e   y o u   w a n t   t o   s a v e   t h e   i m a g e   f i l e . T �� W X
�� 
dfnm W m     Y Y � Z Z  M y B a c k u p . d m g X �� [��
�� 
dflc [ I   �� \��
�� .earsffdralis        afdr \ m    ��
�� afdrdesk��  ��   Q o      ���� 0 thefile theFile O  ] ^ ] l  " "��������  ��  ��   ^  _ ` _ l  " "�� a b��   a  	  warning    b � c c      w a r n i n g `  d e d I  " I�� f g
�� .sysodlogaskr        TEXT f m   " # h h � i i � B e   p a t i e n t .   T h e   b a c k u p   m a y   t a k e   c o n s i d e r a b l e   t i m e .   Y o u   w i l l   b e   n o t i f i e d   u p o n   c o m p l e t i o n . g �� j k
�� 
appr j o   $ )���� 0 thetitle theTitle k �� l m
�� 
btns l J   , 1 n n  o�� o m   , / p p � q q  O k��   m �� r s
�� 
dflt r m   4 7 t t � u u  O k s �� v w
�� 
givu v m   : =����  w �� x��
�� 
disp x m   @ C��
�� stic   ��   e  y z y l  J J��������  ��  ��   z  { | { l  J J�� } ~��   }    make disk image    ~ �   "     m a k e   d i s k   i m a g e |  � � � r   J g � � � I  J e�� � �
�� .sysoexecTEXT���     TEXT � l  J ] ����� � b   J ] � � � b   J W � � � b   J S � � � m   J M � � � � � X / u s r / b i n / h d i u t i l   c r e a t e   - f s   H F S +   - s r c F o l d e r   � n   M R � � � 1   N R��
�� 
psxp � o   M N���� 0 	thesource 	theSource � m   S V � � � � �    � n   W \ � � � 1   X \��
�� 
psxp � o   W X���� 0 thefile theFile��  ��   � �� ���
�� 
badm � m   ` a��
�� boovtrue��   � o      ���� 0 	theresult 	theResult �  � � � I  h m�� ���
�� .ascrcmnt****      � **** � o   h i���� 0 	theresult 	theResult��   �  � � � l  n n��������  ��  ��   �  ��� � Z   n � � ����� � E   n s � � � o   n o���� 0 	theresult 	theResult � m   o r � � � � �  c r e a t e d : � k   v � � �  � � � I  v ��� � �
�� .sysodlogaskr        TEXT � m   v y � � � � � . T h e   b a c k u p   i s   c o m p l e t e . � �� � �
�� 
appr � o   z ���� 0 thetitle theTitle � �� � �
�� 
btns � J   � � � �  ��� � m   � � � � � � �  O k��   � �� � �
�� 
dflt � m   � � � � � � �  O k � �� ���
�� 
givu � m   � ����� ��   �  ��� � I  � ��� ���
�� .sysottosnull���     TEXT � m   � � � � � � � $ B a c k u p   i s   c o m p l e t e��  ��  ��  ��  ��   3  � � � l     ��������  ��  ��   �  ��� � i    
 � � � I      �������� 0 restore  ��  ��   � k     � � �  � � � l     �� � ���   �    get disk image to mount    � � � � 2     g e t   d i s k   i m a g e   t o   m o u n t �  � � � r      � � � I    ���� �
�� .sysostdfalis    ��� null��   � �� � �
�� 
ftyp � m     � � � � �  d e v i � �� � �
�� 
prmp � m     � � � � � � S e l e c t   a   d i s k   i m a g e   f i l e   t h a t   c o n t a i n s   a   c o p y   o f   a   u s e r ' s   p r o f i l e   t o   r e s t o r e . � �� ���
�� 
dflc � I   �� ���
�� .earsffdralis        afdr � m    ��
�� afdrdesk��  ��   � o      ���� 0 thefile theFile �  � � � l   ��������  ��  ��   �  � � � l   � � ��   �    mount disk image     � � � � &     m o u n t   d i s k   i m a g e   �  � � � r     � � � I   �~ ��}
�~ .sysoexecTEXT���     TEXT � l    ��|�{ � b     � � � b     � � � m     � � � � � . / u s r / b i n / h d i u t i l   m o u n t   � n     � � � 1    �z
�z 
psxp � o    �y�y 0 thefile theFile � m     � � � � � L |   g r e p   ' / V o l u m e s '   |   a w k   ' {   p r i n t   $ 3   } '�|  �{  �}   � o      �x�x 0 themountpath theMountPath �  � � � I    %�w ��v
�w .ascrcmnt****      � **** � o     !�u�u 0 themountpath theMountPath�v   �  � � � l  & &�t�s�r�t  �s  �r   �  � � � l  & &�q � ��q   � 6 0  get folder where user's profile will be copied    � � � � `     g e t   f o l d e r   w h e r e   u s e r ' s   p r o f i l e   w i l l   b e   c o p i e d �  � � � r   & 7 � � � I  & 5�p�o �
�p .sysostflalis    ��� null�o   � �n � �
�n 
prmp � m   ( ) � � � � � � S e l e c t   t h e   u s e r ' s   h o m e   f o l d e r   w h e r e   t h e   p r o f i l e   w i l l   b e   r e t o r e d . � �m ��l
�m 
dflc � I  * /�k ��j
�k .earsffdralis        afdr � m   * +�i
�i afdrusrs�j  �l   � o      �h�h  0 thedestination theDestination �    l  8 8�g�f�e�g  �f  �e    l  8 8�d�d    	  warning    �      w a r n i n g  I  8 c�c	

�c .sysodlogaskr        TEXT	 m   8 ; � � B e   p a t i e n t .   T h e   r e s t o r e   m a y   t a k e   c o n s i d e r a b l e   t i m e .   Y o u   w i l l   b e   n o t i f i e d   u p o n   c o m p l e t i o n .
 �b
�b 
appr o   > C�a�a 0 thetitle theTitle �`
�` 
btns J   F K �_ m   F I �  O k�_   �^
�^ 
dflt m   N Q �  O k �]
�] 
givu m   T W�\�\  �[�Z
�[ 
disp m   Z ]�Y
�Y stic   �Z    l  d d�X�W�V�X  �W  �V    l  d d�U !�U    "   copy data to user's folder   ! �"" 8     c o p y   d a t a   t o   u s e r ' s   f o l d e r #$# r   d {%&% I  d y�T'(
�T .sysoexecTEXT���     TEXT' l  d q)�S�R) b   d q*+* b   d m,-, b   d i./. m   d g00 �11  / u s r / b i n / d i t t o  / o   g h�Q�Q 0 themountpath theMountPath- m   i l22 �33   + n   m p454 1   n p�P
�P 
psxp5 o   m n�O�O  0 thedestination theDestination�S  �R  ( �N6�M
�N 
badm6 m   t u�L
�L boovtrue�M  & o      �K�K 0 	theresult 	theResult$ 787 I  | ��J9�I
�J .ascrcmnt****      � ****9 o   | }�H�H 0 	theresult 	theResult�I  8 :;: l  � ��G�F�E�G  �F  �E  ; <=< l  � ��D>?�D  >    unmount disk image   ? �@@ (     u n m o u n t   d i s k   i m a g e= ABA I  � ��CC�B
�C .sysoexecTEXT���     TEXTC l  � �D�A�@D b   � �EFE m   � �GG �HH . / u s r / b i n / h d i u t i l   e j e c t  F o   � ��?�? 0 themountpath theMountPath�A  �@  �B  B IJI l  � ��>�=�<�>  �=  �<  J K�;K Z   � �LM�:�9L =  � �NON o   � ��8�8 0 	theresult 	theResultO m   � �PP �QQ  M k   � �RR STS I  � ��7UV
�7 .sysodlogaskr        TEXTU m   � �WW �XX 0 T h e   r e s t o r e   i s   c o m p l e t e .V �6YZ
�6 
apprY o   � ��5�5 0 thetitle theTitleZ �4[\
�4 
btns[ J   � �]] ^�3^ m   � �__ �``  O k�3  \ �2ab
�2 
dflta m   � �cc �dd  O kb �1e�0
�1 
givue m   � ��/�/ �0  T f�.f I  � ��-g�,
�- .sysottosnull���     TEXTg m   � �hh �ii & R e s t o r e   i s   c o m p l e t e�,  �.  �:  �9  �;  ��       
�+j klmn�*�)�(�+  j �'�&�%�$�#�"�!� �' 0 thetitle theTitle�& 
0 backup  �% 0 restore  
�$ .aevtoappnull  �   � ****�# $0 thedialogresults theDialogResults�"  �!  �   k � 5��op�� 
0 backup  �  �  o ���� 0 	thesource 	theSource� 0 thefile theFile� 0 	theresult 	theResultp '� C������ U� Y��� h�� p� t�
�	���� �� ���� � � � ��  ���
� 
prmp
� 
dflc
� afdrusrs
� .earsffdralis        afdr� 
� .sysostflalis    ��� null
� 
prmt
� 
dfnm
� afdrdesk� 
� .sysonwflfile    ��� null
� 
appr
� 
btns
� 
dflt
�
 
givu�	 
� 
disp
� stic   � 

� .sysodlogaskr        TEXT
� 
psxp
� 
badm
� .sysoexecTEXT���     TEXT
� .ascrcmnt****      � ****�  
�� .sysottosnull���     TEXT� �*����j � E�O*������j � E�O��b   a a kva a a a a a a  Oa �a ,%a %�a ,%a el E�O�j O�a   0a !�b   a a "kva a #a a a $ Oa %j &Y hl �� �����qr���� 0 restore  ��  ��  q ���������� 0 thefile theFile�� 0 themountpath theMountPath��  0 thedestination theDestination�� 0 	theresult 	theResultr )�� ��� ����������� ��� ����� �������������������������02��GPW_c��h��
�� 
ftyp
�� 
prmp
�� 
dflc
�� afdrdesk
�� .earsffdralis        afdr�� 
�� .sysostdfalis    ��� null
�� 
psxp
�� .sysoexecTEXT���     TEXT
�� .ascrcmnt****      � ****
�� afdrusrs�� 
�� .sysostflalis    ��� null
�� 
appr
�� 
btns
�� 
dflt
�� 
givu�� 
�� 
disp
�� stic   �� 

�� .sysodlogaskr        TEXT
�� 
badm�� 
�� .sysottosnull���     TEXT�� �*������j � E�O��,%�%j E�O�j O*����j a  E�Oa a b   a a kva a a a a a a  Oa �%a %��,%a  el E�O�j Oa !�%j O�a "  2a #a b   a a $kva a %a a a & Oa 'j (Y hm ��s����tu��
�� .aevtoappnull  �   � ****s k     )vv  ww  $����  ��  ��  t  u  ����   "�������� .����
�� 
appr
�� 
btns�� 
�� .sysodlogaskr        TEXT�� $0 thedialogresults theDialogResults
�� 
bhit�� 
0 backup  �� 0 restore  �� *��b   ����mv� E�O��,�  
*j+ Y *j+ n ��x��
�� 
bhitx �yy  B a c k u p��  �*  �)  �(   ascr  ��ޭ