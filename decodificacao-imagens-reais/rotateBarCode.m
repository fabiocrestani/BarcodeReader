function [extractedBarCode1Rotate] = rotateBarCode(extractedBarCode1, ...
    debug)
% Endireita (rotaciona) o código de barras descobrindo o ângulo
% predominante das linhas verticais. Utiliza para tal, a transformada de 
% Hough.

    Ibw = ~im2bw(extractedBarCode1, graythresh(extractedBarCode1)); 
    [H,theta,rho] = hough(Ibw);
    peaks  = houghpeaks(H, 45);
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
                title('Resultado da transformada de Hough');
            end
        end
    end
    
    if debug
        hold off;
    end
    
    angle = mean(validAngles);
    if ~isnan(angle)
        extractedBarCode1Rotate = imrotate(extractedBarCode1, angle, ...
        'bilinear', 'crop');
    
        % Corrige bordas pretas resultantes do imrotate
        mask = true(size(extractedBarCode1));
        maskRotated = ~imrotate(mask, angle, 'crop');
        extractedBarCode1Rotate(maskRotated) = 255;
    else
        extractedBarCode1Rotate = extractedBarCode1;
    end
    
    if debug
        figure; imshowpair(extractedBarCode1, extractedBarCode1Rotate, ...
            'falsecolor');
%         hold on;
%         rectangle('Position', [900 1 2 500], 'Linewidth', 2, ...
%             'EdgeColor', 'g');
%         hold off;
        title('extractedBarCode1 e extractedBarCode1Rotate');
    end
end