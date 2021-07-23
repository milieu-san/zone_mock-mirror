namespace :db do
  task apply: :environment do
    system "bundle exec ridgepole --apply -c config/database.yml -E #{Rails.env} -f db/Schemafile --mysql-change-table-options"
    system "bundle exec annotate -i" if Rails.env.development?
  end
end
