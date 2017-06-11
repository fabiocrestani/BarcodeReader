function [extractedBarCode1Rotate] = rotateBarCode(extractedBarCode1, ...
    debug)
% Endireita (rotaciona) o código de barras descobrindo o ângulo
% predominante das linhas verticais. Utiliza para tal, a transformada de 
% Hough.

    Ibw = ~im2bw(extractedBarCode1, graythresh(extractedBarCode1)); 
    [H,theta,rho] = hough(Ibw);
    peaks  = houghpeaks(H, 30);
    lines = houghlines(Ibw, theta, rho, peaks);

    if debug
        figure, imshow(Ibw);
        hold on;
    end
    
    validAngles = [];
    for k = 1:numel(lines)
        if abs(lines(k).theta) < 10
            validAngles = [validAngles lines(k).theta];
            if debug
                x1 = lines(k).point1(1);
                y1 = lines(k).point1(2);
                x2 = lines(k).point2(1);
                y2 = lines(k).point2(2);
                plot([x1 x2],[y1 y2],'Color','g','LineWidth', 2)
            end
        end
    end
    
    if debug
        hold off;
    end
    
    angle = mean(validAngles);
    extractedBarCode1Rotate = imrotate(extractedBarCode1, angle, ...
        'bilinear');
    
    if debug
        figure; imshowpair(extractedBarCode1, extractedBarCode1Rotate, ...
            'montage');
        hold on;
        rectangle('Position', [900 1 2 500], 'Linewidth', 2, ...
            'EdgeColor', 'g');
        hold off;
        title('extractedBarCode1 e extractedBarCode1Rotate');
    end
end