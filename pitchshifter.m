clear all

%各種設定
frameLength = 512;
frameShift = frameLength/2;
pitchShift = 32;

%音声データのダウンロード
[y,Fs]=audioread('C:/Users/SOGE/Music/gion.wav');
%{
%音声のフレーム化
yFrame = block1d(y, frameLength, frameShift);
%ハミング窓関数
hammwin = transpose(0.54 - 0.46*cos(2*pi*(0:frameLength - 1) / (frameLength - 1)));
%各フレームに窓を掛ける
yFrame = yFrame.*repmat(hammwin, 1, size(yFrame,2));
%フレームごとにfftを施す
%fftは各列のフーリエ変換を施す
yFFT = fft(yFrame);

%周波数成分をpitchShift分高域側にシフトし空いたとことをゼロで埋める
%ただし直流成分はそのまま残す
shiftFFT =[
 yFFT(1,:);
 zeros(pitchShift,size(yFFT,2));
 yFFT([2:frameLength/2 - pitchShift frameLength/2 + 1],:)];
%周波数の折り返し成分を付加
shiftFFT = [shiftFFT; flipud(conj(shiftFFT(2:frameLength/2,:)))];
%逆fft
cy = ifft(shiftFFT);

%重複加算によりフレームを時系列に戻す
recY = zeros(frameLength,1);
WAITBAR = waitbar(0,'Please wait...');
for i = 1:size(cy,2)
  rry = [zeros((i - 1)*frameShift,1); cy(:,i); zeros(frameShift,1)];
  ry = [recY; zeros(frameShift,1)];
  recY = ry + rry;
  waitbar(i/size(cy,2));
end
close(WAITBAR);

disp('Calculation is finished.Please press any keys!');
pause;
%}
%音声の再生
%sound(y,Fs) Octaveは対応していない
sound(y);


disp('Please press any keys!');
pause;
%sound(recY,Fs);
%sound(recY);


