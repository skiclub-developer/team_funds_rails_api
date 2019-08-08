ActiveAdmin.register Penalty do
  permit_params [:penalty_name, :penalty_cost, :case_of_beer_cost]
end
