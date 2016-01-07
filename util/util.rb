require 'yaml'

ENV_PREFIX='VAGRANT_ENV_'

# http://stackoverflow.com/a/9381776/1068746
class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| if Hash === v1 && Hash === v2 then v1.merge(v2, &merger) else v2 end}
    self.merge(second, &merger)
  end
end

class Util

  def getConfigs(configFile, cloudname)

    unless configFile
      abort("\n\n\n\nMUST DEFINE VARIABLE `CONFIG_FILE` TO POINT TO JSON OR YAML CONFIGURATION. see `defaults.json` file for configuration example\n\n\n")
    end

    defaults = YAML.load_file("../"+cloudname+"/defaults.json")

    ## allow to define environment variables that we will pass to
    defaults['environmentVariables'] = ENV.select { | name | name.start_with?  ENV_PREFIX  }
    defaults['environmentVariables'].keys.each { | k | defaults['environmentVariables'][ k[ENV_PREFIX.length, k.length-1]] = defaults['environmentVariables'][k]; defaults['environmentVariables'].delete(k); }

    configs = YAML.load_file("#{configFile}")

    configs = defaults.deep_merge(configs)

    return configs
  end

  def initEnvironmentProvision(configs)

    environment_provision_script = "echo \""
    if configs.has_key?("environmentVariables")
      configs['environmentVariables'].each { |k, v| environment_provision_script = environment_provision_script + "export #{k}=\\\"#{v}\\\";\n" }
    end
    environment_provision_script = environment_provision_script + "\" > /etc/ENVIRONMENT_VARIABLES.sh"

    return environment_provision_script
  end

  def setVagrantignore(excludes_array)
    #:rsync_excludes => ['chef/tmp', 'tmp']

    begin
      excludes_array = IO.readlines("../synced_folder/.vagrantignore")
      excludes_array.collect { |x| x.strip! }
    rescue
      puts '.vagrantignore does not exist. moving on..'
    end
    puts "the following files will be ignored by rsync #{excludes_array}"
    puts "see https://docs.vagrantup.com/v2/synced-folders/rsync.html for recommended list of ignore items"

  end
end
