namespace :brakeman do
  desc "Run Brakeman security scan"
  task :run do
    require "brakeman"
    Brakeman.run app_path: Rails.root.to_s, output_files: [ "brakeman-report.html", "brakeman-report.json" ]
  end
end
