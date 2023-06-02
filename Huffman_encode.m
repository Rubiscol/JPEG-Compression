function [original_width, original_height, width, height, encodedArray, dictionary] = Huffman_encode(frequency_array) 
%frequency_array.shape = M*N, if M, N are multiples of 8
%frequency_array type: int16
%encodedArray = Huffman encoded array
%dictionary = Huffman dictionary

    shift_const = 32768;
    zigzag=[64 63 62 61 60 59 58 57;
            37 36 35 34 33 32 31 56;
            38 17 16 15 14 13 30 55;
            39 18 5  4  3  12 29 54;
            40 19 6  1  2  11 28 53;
            41 20 7  8  9  10 27 52;
            42 21 22 23 24 25 26 51;
            43 44 45 46 47 48 49 50];
    
    sizef = size(frequency_array);
    original_width = sizef(1);
    original_height = sizef(2);
    

    %adjust width and height
    width = (floor(original_width/8) + 1) * 8;
    height = (floor(original_height/8) + 1) * 8;
    temp = zeros(width, height);
    temp(1:original_width, 1:original_height) = frequency_array;
    frequency_array = temp;
    
    flatten_original_array = zeros(1, width*height);
    end_pointer = 1; %end point of flatten_original_array

    for x = 1:8:width-7 %numerate starting point of width
        for y = 1:8:height-7 %numerate starting point of height
            block = frequency_array(x:x+7, y:y+7);
            %Flatten block zigzag-ly
            for i = 1:8
                for j =1:8
                    ind = end_pointer + zigzag(i,j) -1;
                    flatten_original_array(ind) = block(i,j);
                end
            end
            end_pointer = end_pointer + 64;
        end
    end
%     prod(size(flatten_original_array))*16
    erased_array = zeros(1, width*height); 
    erased_end_pointer = 1;
    %erase 0 for each block
    temp = size(flatten_original_array);
    for original_pointer = 1:64:temp(2)-63 %start of each flatten block
        %find all 0s
        end_pos = original_pointer + 63;
        while end_pos >= original_pointer 
            %stop just before all 0s in a block
            if flatten_original_array(end_pos) ~= 0
                break
            end
            end_pos = end_pos-1;
        end
        
        %copy before all 0s
        for i = original_pointer:end_pos
            erased_array(erased_end_pointer) = flatten_original_array(i);
            erased_end_pointer = erased_end_pointer + 1;
        end
        %symbol for all 0s
        %not always exist for every block
        if end_pos ~=  original_pointer + 63 %mod(end_pos, 64) ~= 0
            erased_array(erased_end_pointer) = -shift_const;
            erased_end_pointer = erased_end_pointer + 1;
        end
    end
    

    %Huffman encode
    erased_array = erased_array(1:erased_end_pointer-1);
%     prod(size(erased_array))*16
    %disp("______________")
    %disp(erased_array)

%   Update: calculate the symbols and corresponding prob
    symbols= unique(erased_array);
    size(symbols);
    N = numel(symbols);
    prob = zeros(1,N);
    for k = 1:N
        prob(k) = sum(erased_array==symbols(k));
    end
    prob=prob/length(erased_array);
    size(prob);
    dictionary = huffmandict(symbols, prob);
    
    
    encodedArray = huffmanenco(erased_array, dictionary);
%     prod(size(encodedArray))
    %disp(8*prod(size(erased_array)))
    %disp(length(encodedArray))
    %
    %encodedArray = erased_array;
end
