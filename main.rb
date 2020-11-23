require 'json'
require 'yaml'

def get_env_variable(key)
	return (ENV[key] == nil || ENV[key] == "") ? nil : ENV[key]
end

ac_project_dir = get_env_variable("AC_PROJECT_DIR") || abort('Missing AC_PROJECT_DIR.')
ac_output_folder = get_env_variable("AC_OUTPUT_DIR") || abort('Missing output folder.')

package_json_path = "#{ac_project_dir}/package.json"

input =  JSON.parse(File.read(package_json_path))
dependencies = JSON.pretty_generate(input["dependencies"])
devDependencies = JSON.pretty_generate(input["devDependencies"])

output = "{
    \"dependencies\": #{dependencies},
    \"devDependencies\": #{devDependencies}
}"

dependency_report_path = "#{ac_output_folder}/nodeDependencies.json"
File.open("#{dependency_report_path}","w") do |f|
    f.write(output)
end

puts "Exporting AC_NODE_DEPENDENCY_REPORT_PATH=#{dependency_report_path}"

open(ENV['AC_ENV_FILE_PATH'], 'a') { |f|
    f.puts "AC_NODE_DEPENDENCY_REPORT_PATH=#{dependency_report_path}"
}

exit 0