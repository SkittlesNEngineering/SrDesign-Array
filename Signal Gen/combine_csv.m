function combine_csv(tx1_filename,tx2_filename)

tx1_table = readtable(tx1_filename);
tx2_table = readtable(tx2_filename);
tx2_table = renamevars(tx2_table,["Var1","Var2"],["Var3","Var4"]);
combined_table = [tx1_table tx2_table];
combined_table(1,:) = [];
writetable(combined_table, 'leader_zero.csv', 'Delimiter',',');
    
end