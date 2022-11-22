namespace :users do
  desc "Update all users score"
  task update_all: :environment do
    UpdateUserJob.perform_later
  end
end
