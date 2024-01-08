function spaceMatrix = getSpaceMatrix(spaceMatrix, ampAtTime)
%% LEFT SUBFIELD

% in first index 1 = 65um
% in the second index 1 = 75um
% is 26 by 38
% % for i = 1:length(ampAtTime)
% %     if ampAtTime(i) == 0
% %         ampAtTime(i) = -0.0001;
% %     end
% % end


spaceMatrix(1,3) = ampAtTime(33);
spaceMatrix(1,5) = ampAtTime(35);
spaceMatrix(1,7) = ampAtTime(42);
spaceMatrix(1,9) = ampAtTime(50);
spaceMatrix(1,11) = ampAtTime(58);

spaceMatrix(3,2) = ampAtTime(28);
spaceMatrix(3,4) = ampAtTime(34);
spaceMatrix(3,6) = ampAtTime(41);
spaceMatrix(3,8) = ampAtTime(49);
spaceMatrix(3,10) = ampAtTime(57);

spaceMatrix(5,3) = ampAtTime(25);
spaceMatrix(5,5) = ampAtTime(27);
spaceMatrix(5,7) = ampAtTime(18);
spaceMatrix(5,9) = ampAtTime(9);
spaceMatrix(5,11) = ampAtTime(43);

spaceMatrix(7,4) = ampAtTime(26);
spaceMatrix(7,6) = ampAtTime(17);
spaceMatrix(7,8) = ampAtTime(19);
spaceMatrix(7,10) = ampAtTime(1);

% TOP SUBFIELD

spaceMatrix(26,14) = ampAtTime(3);
spaceMatrix(26,16) = ampAtTime(12);
spaceMatrix(26,18) = ampAtTime(29);
spaceMatrix(26,20) = ampAtTime(13);
spaceMatrix(26,22) = ampAtTime(6);

spaceMatrix(24,13) = ampAtTime(11);
spaceMatrix(24,15) = ampAtTime(20);
spaceMatrix(24,17) = ampAtTime(4);
spaceMatrix(24,19) = ampAtTime(5);
spaceMatrix(24,21) = ampAtTime(21);
spaceMatrix(24,23) = ampAtTime(14);

spaceMatrix(22,12) = ampAtTime(2);
spaceMatrix(22,14) = ampAtTime(51);
spaceMatrix(22,16) = ampAtTime(44);
spaceMatrix(22,18) = ampAtTime(60);
spaceMatrix(22,20) = ampAtTime(61);
spaceMatrix(22,22) = ampAtTime(45);
spaceMatrix(22,24) = ampAtTime(22);

spaceMatrix(20,13) = ampAtTime(10);
spaceMatrix(20,15) = ampAtTime(59);
spaceMatrix(20,17) = ampAtTime(52);
spaceMatrix(20,19) = ampAtTime(36);
spaceMatrix(20,21) = ampAtTime(53);
spaceMatrix(20,23) = ampAtTime(7);

% RIGHT SUBFIELD

spaceMatrix(13,26) = ampAtTime(8);
spaceMatrix(13,28) = ampAtTime(15);
spaceMatrix(13,30) = ampAtTime(16);
spaceMatrix(13,32) = ampAtTime(23);
spaceMatrix(13,34) = ampAtTime(24);
spaceMatrix(13,36) = ampAtTime(30);
spaceMatrix(13,38) = ampAtTime(31);

spaceMatrix(11,25) = ampAtTime(62);
spaceMatrix(11,27) = ampAtTime(63);
spaceMatrix(11,29) = ampAtTime(64);
spaceMatrix(11,31) = ampAtTime(46);
spaceMatrix(11,33) = ampAtTime(48);
spaceMatrix(11,35) = ampAtTime(39);
spaceMatrix(11,37) = ampAtTime(32);

spaceMatrix(9,26) = ampAtTime(54);
spaceMatrix(9,28) = ampAtTime(55);
spaceMatrix(9,30) = ampAtTime(56);
spaceMatrix(9,32) = ampAtTime(47);
spaceMatrix(9,34) = ampAtTime(38);
spaceMatrix(9,36) = ampAtTime(40);
spaceMatrix(9,38) = ampAtTime(37);



spaceMatrix = [spaceMatrix, zeros(size(spaceMatrix,1),1)];
spaceMatrix = [zeros(size(spaceMatrix,1),1), spaceMatrix];

spaceMatrix = [spaceMatrix; zeros(1,size(spaceMatrix,2))];
spaceMatrix = [zeros(1,size(spaceMatrix,2)); spaceMatrix];
end