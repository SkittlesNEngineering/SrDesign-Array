function combine_csv(tx1_filename,tx2_filename)
tx1_csv = csvread(tx1_filename);
tx2_csv = csvread(tx2_filename);

combined = [tx1_csv;tx2_csv]; % Concatenate vertical
csvwrite('leader_zero', combined)
end