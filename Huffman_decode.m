function [frequency_array] = Huffman_decode(original_width, original_height, width, height, encodedArray, huffman_dictionary)

    shift_const = 32768;
    zigzag=[64 63 62 61 60 59 58 57;
            37 36 35 34 33 32 31 56;
            38 17 16 15 14 13 30 55;
            39 18 5 4 3 12 29 54;
            40 19 6 1 2 11 28 53;
            41 20 7 8 9 10 27 52;
            42 21 22 23 24 25 26 51;
            43 44 45 46 47 48 49 50];
    inv_zigzag_x = dictionary();
    inv_zigzag_y = dictionary();%double -> tuple
    inv_zigzag_x(0) = 8;
    inv_zigzag_y(0) = 8;
    for i = 1:8
        for j =1:8
            inv_zigzag_x(zigzag(i,j)) = i;
            inv_zigzag_y(zigzag(i,j)) = j;
        end
    end

    %tic
    %decode
    erased_array = huffmandeco(encodedArray, huffman_dictionary);

    %toc
    %disp(['--', num2str(toc)])

    %restore all 0s
    flatten_original_array = zeros(1,width*height);
    flatten_pointer = 1;
    
    temp = size(erased_array);
    for erased_pointer = 1:temp(2)
        element = erased_array(erased_pointer);
        if element ~= -shift_const
            flatten_original_array(flatten_pointer) = erased_array(erased_pointer);
            flatten_pointer = flatten_pointer + 1;
        else
            flatten_pointer = floor((flatten_pointer-1)/64) * 64 + 64+1; %skip the block
            %disp(flatten_pointer)
        end
    end

    %restore block-wise zigzag flatten
    frequency_array = zeros(width, height);
    width_pointer = 0; %just at left of the starting point
    height_pointer = 0; %just at top of the starting point
    temp = size(flatten_original_array);

    for flatten_pointer = 1:temp(2)
        i = inv_zigzag_x( mod(flatten_pointer,64) );
        j = inv_zigzag_y( mod(flatten_pointer,64) );

        frequency_array(width_pointer+i, height_pointer+j) = flatten_original_array(flatten_pointer); 

        if mod(flatten_pointer,64) == 0  %move block pointer
            height_pointer = height_pointer + 8;
            if height_pointer >= height
                width_pointer = width_pointer + 8;
                height_pointer = 0;
            end

        end
    end
    
    %back to original width*height
    frequency_array = frequency_array(1:original_width, 1:original_height);
end