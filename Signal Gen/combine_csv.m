tx1_csv = csvread(file1);
tx2_csv = csvread(file2);

combined = [tx1_csv;tx2_csv]; % Concatenate vertical
csvwrite(outputfilename, combined)