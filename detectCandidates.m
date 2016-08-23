function rectangles = detectCandidates(img)
  pkg load image;
  
  #Transform image to greyscale
  grayscale_img = rgb2gray(img);
  visited = zeros(rows(grayscale_img), columns(grayscale_img));
  
  rectangles = [0];
  
  for i = 1:rows(grayscale_img)
    for j = 1:columns(grayscale_img)
      if(visited(i, j) == 0)                  #THIS PIXEL HASN'T BEEN VISITED
        if(grayscale_img(i, j) != 255)        #THIS PIXEL IS NOT A BACKGROUND PIXEL
          upper_bound = i;
          lower_bound = i + 3;
          right_bound = j + 3;
          left_bound = j;
          
          done = 0;
          
          while(done == 0)
            if(visited(upper_bound - 1, left_bound:right_bound) == 0)           #look up
              visited(upper_bound - 1, left_bound:right_bound) = 1;
              
              if(grayscale_img(upper_bound - 1, left_bound:right_bound) != 255) #its not background
                upper_bound = upper_bound - 1;
              endif
            elseif(visited(lower_bound + 1, left_bound:right_bound) == 0)       #look down
              visited(lower_bound + 1, left_bound:right_bound) = 1;
              
              if(grayscale_img(lower_bound + 1, left_bound:right_bound) != 255)
                lower_bound = lower_bound + 1;
              endif
            elseif(visited(upper_bound:lower_bound, left_bound - 1) == 0)       #look left
              visited(upper_bound:lower_bound, left_bound - 1) = 1;
              
              if(grayscale_img(upper_bound:lower_bound, left_bound - 1) != 255) 
                left_bound = left_bound - 1;
              endif
            elseif(visited(upper_bound:lower_bound, right_bound + 1) == 0)      #look right
              visited(upper_bound:lower_bound, right_bound + 1) = 0;
              
              if(grayscale_img(upper_bound:lower_bound, right_bound + 1) != 255) 
                right_bound = right_bound + 1;
              endif
            else
              done = 1;                                                         #all sides are background
            endif
          endwhile
          
          rect = [upper_bound, left_bound, right_bound - left_bound, lower_bound - upper_bound];
          
          temp = zeros(length(rectangles) + 1);
          
          for r = 1:length(rectangles)
            temp(r) = rectangles(r);
          
          endfor
          temp(length(rectangles)) = imcrop(img, rect);
          
          rectangles = temp;
        endif
      endif
    endfor
  endfor
  
endfunction