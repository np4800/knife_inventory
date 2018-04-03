require 'chef/knife'
require 'highline'

module Limelight
  class Inventory < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
      require 'chef/node'
      require 'chef/json_compat'
      require 'chef/knife/node_list'
    end

    banner "knife inventory"

    def h
      @highline ||= Highline.new
    end

    def run

      ubuntuNodes = 0
      centosNodes = 0
      redhatNodes = 0
      suseNodes = 0
      unknownOs = 0

      development = 0
      production = 0
      testing = 0
      default = 0
      quality_assurance =0

      totalNodes = 0

      nodes = Hash.new
      Chef::Search::Query.new.search(:node, "*:*") do |n|
	    node = n unless n.nil?
        totalNodes += 1
        defined?(node['platform']) || node['platform'] = "empty"
        defined?(node.chef_environment) || node.chef_environment = "empty"
        platform = node['platform']
        environment = node.chef_environment

        if platform == "ubuntu"
          ubuntuNodes += 1
        elsif platform == "centos"
          centosNodes += 1
        elsif platform == "redhat"
          redhatNodes += 1
        elsif platform == 'suse'
          suseNodes += 1
        else
          unknownOs += 1
        end

        if environment == 'development'
          development += 1
        elsif environment == 'production'
          production += 1
        elsif environment == 'testing'
          testing += 1
        elsif environment == '_default'
          default += 1
        elsif environment == 'quality_assurance'
          quality_assurance += 1
        end
    end

    print "Environment,Total Count,,OS,Total Count\n"
    print "development,#{development},,Ubuntu,#{ubuntuNodes}\n"
    print "production,#{production},,RedHat,#{redhatNodes}\n"
    print "testing,#{testing},,SUSE,#{suseNodes}\n"
    print "quality_assurance,#{quality_assurance},,Centos,#{centosNodes}\n"
    print "default,#{default},,UnkownOS,#{unknownOs}\n"

    print "\n"

    print "Total,#{totalNodes}\n"

    print "\n"

    print "Name,FQDN,Environment,Platform,Platform Version,IP,System Type,CPUs,Memory,Kernel Release,Kernel Version,Uptime,Idletime,Pacakges Installed\n"
    nodes = Hash.new
    Chef::Search::Query.new.search(:node, "*:*") do |n|
	  node = n unless n.nil?

      ##THIS COULD BE BETTER *WAY* BETTER
	defined?(node.name) || node.name = "empty"
	defined?(node['fqdn']) || node['fqdn'] = "empty"
	defined?(node.chef_environment) || node.chef_environment = "empty"
	defined?(node.run_list) || node.run_list = "empty"
	defined?(node['tags']) || node['tags'] = "empty"
	defined?(node['roles']) || node['roles'] = "empty"
	defined?(node['kernel']) || node['kernel'] = Hash.new
	defined?(node['kernel']['release']) || node['kernel']['release'] = "empty"
  defined?(node['kernel']['version']) || node['kernel']['version'] = "empty"
	defined?(node['platform']) || node['platform'] = "empty"
	defined?(node['platform_version']) || node['platform_version'] = "empty"
	defined?(node['ipaddress']) || node['ipaddress'] = "empty"
	defined?(node['macaddress']) || node['macaddress'] = "empty"
	defined?(node['memory']) || node['memory'] = Hash.new
	defined?(node['memory']['total']) || node['memory']['total'] = "empty"
	defined?(node['memory']['swap']) || node['memory']['swap'] = Hash.new
	defined?(node['memory']['swap']['total']) || node['memory']['swap']['total'] = "empty"
	defined?(node['network']) || node['network'] = Hash.new
  defined?(node['network']['default_interface']) || node['network']['default_interface'] = "empty"
	defined?(node['network']['default_gateway']) || node['network']['default_gateway'] = "empty"
	defined?(node['chef_packages']) || node['chef_packages'] = Hash.new
	defined?(node['chef_packages']['chef']) || node['chef_packages']['chef'] = Hash.new
	defined?(node['chef_packages']['chef']['version']) || node['chef_packages']['chef']['version'] = "empty"
	defined?(node['cpu']) || node['cpu'] = Hash.new
	defined?(node['cpu']['total']) || node['cpu']['total'] = "empty"
	defined?(node['virtualization']['system']) || node['virtualization']['system'] = "empty"
  defined?(node['cpu']['total']) || node['cpu']['total'] = "empty"
  defined?(node['idleltime']) || node['idletime'] = "empty"
  defined?(node['uptime']) || node['uptime'] = "empty"
  defined?(node['packages']) || node['packages'] = "empty"

	if node.run_list.recipes.include?("proxy")
	  has_proxy="yes"
	else
	  has_proxy="no"
	end

	name = node.name
	fqdn = node['fqdn']
	environment = node.chef_environment
	run_list = node.run_list
	roles = node['roles']
	kernel = node['kernel']['release']
  kernel_version = node['kernel']['version']
	platform = node['platform']
	platform_ver = node['platform_version']
	ip = node['ipaddress']
	ram = node['memory']['total']
	swap = node['memory']['swap']['total']
	default_nic = node['network']['default_interface']
	macaddress = node['macaddress']
	df_gateway = node['network']['default_gateway']
	chef_version = node['chef_packages']['chef']['version']
	cpu_num = node['cpu']['total']
	tags = node['tags']
	virtualization_system = node['virtualization']['system']
	kernel_version = node['kernel']['version']
  uptime = node['uptime']
  idletime = node['idletime']
  packages = node['packages']

	# print "#{name},#{fqdn},#{environment},#{platform},#{platform_ver},#{ip},#{virtualization_system},#{cpu_num},#{ram},#{kernel},#{kernel_version},#{uptime},#{idletime}\n"
	# print "#{name};#{has_proxy};#{fqdn};#{environment};#{run_list};#{tags};#{kernel}\n"
    packages.each do |key, value|
      print "#{name},#{fqdn},#{environment},#{platform},#{platform_ver},#{ip},#{virtualization_system},#{cpu_num},#{ram},#{kernel},#{kernel_version},#{uptime},#{idletime},#{key}\n"
    end
      end
    end
  end
end
