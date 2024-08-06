%% script_test_fcn_PlotTestTrack_breakArrayByNans
% Tests fcn_PlotTestTrack_breakArrayByNans
       
% Revision history:
%      2023_07_14 - S. Brennan
%      -- first write of the code




%% Basic test case - no Nans
test_data = rand(10,2);
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},(1:10)'));

%% Basic test case - all Nans
test_data = nan(10,2);
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[]));

%% Basic test case - all but 1 value is Nan
test_data = [nan(10,1); 2; nan(4,1)];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},11));

%% Basic test case - one nan inside
test_data = [2; 3; 4; nan; 6; 7];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[5; 6]));

%% Basic test case - one nan sequence inside
test_data = [2; 3; 4; nan; nan; nan; 6; 7];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - one nan sequence inside, with one nan at end
test_data = [2; 3; 4; nan; nan; nan; 6; 7; nan];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - one nan sequence inside, with many nan at end
test_data = [2; 3; 4; nan; nan; nan; 6; 7; nan(3,1)];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3]));
assert(isequal(indicies_cell_array{2},[7; 8]));

%% Basic test case - many nan sequences inside, with many nan at end
test_data = [1; 2; 3; 4; nan; 6; nan; 8; 9; nan(3,1)];
indicies_cell_array = fcn_PlotTestTrack_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3; 4]));
assert(isequal(indicies_cell_array{2},6));
assert(isequal(indicies_cell_array{3},[8; 9]));