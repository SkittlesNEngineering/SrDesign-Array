function combine_csv(tx1_filename,tx2_filename)

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
combined_table = [tx1_table tx2_table];
writetable(combined_table, 'leader.csv', 'Delimiter',',')
    
end