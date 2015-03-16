zadar do
  desc "Manage iso files and repositories"
  command :iso do |iso|
    iso.desc "Add repository"
    iso.command :addrepo, :ar do |addrepo|
      addrepo.flag [:url, :u], desc: "Mandatory url for remote repo"
      addrepo.flag [:path, :p], desc: "Mandatory path for local repo"
      addrepo.arg_name 'repo_name', required: true, desc: "Name of the new repo"
      addrepo.action do |_, opts, args|
        repo_name = args.first.to_s
        if opts[:url]
          require 'zadar/services/add_remote_iso_repo'
          call { Zadar::Services::AddRemoteIsoRepo.new(opts.merge(name: repo_name)) }
        elsif opts[:path]
          require 'zadar/services/add_local_iso_repo'
          call { Zadar::Services::AddLocalIsoRepo.new(opts.merge(name: repo_name)) }
        else
          failure! "Please specify --url or --path for the repository"
        end
      end
    end

    iso.desc "List repos"
    iso.command :listrepos, :lr do |listrepos|
      listrepos.switch :local, desc: "List local repos", negatable: false
      listrepos.switch :remote, desc: "List remote repos", negatable: false
      listrepos.action do |_, opts, _|
        if opts[:local]
          require 'zadar/services/find_local_iso_repos'
          repos = Zadar::Services::FindLocalIsoRepos.new.call.repos
          failure! "No iso repository found" if repos.empty?
          puts Zadar::Models::LocalIsoRepo.columns.columnize
          repos.each {|r| puts r.to_hash.values.columnize }
        elsif opts[:remote]
          repos = Zadar::Models::RemoteIsoRepo.all
          failure! "No repository found" if repos.empty?
          puts Zadar::Models::RemoteIsoRepo.columns.columnize
          repos.each {|r| puts r.to_hash.values.columnize }
        else
          #TODO show all types of repositories
        end
      end
    end

    iso.desc "List files"
    iso.command :listfiles, :lf do |lsfiles|
      lsfiles.flag [:repo, :r], desc: "Name of the repository"
      lsfiles.action do |_, opts, _|
        require 'zadar/services/find_iso_files'
        failure! "Please specify name of the repository by using --repo" unless opts[:repo]
        result = Zadar::Services::FindIsoFiles.new(repo_name: opts[:repo]).call
        failure! "No files found for repo #{results.repo.name}" if result.files.size.zero?
        puts Zadar::Models::RemoteIsoFile.columns.columnize
        result.files.each {|r| puts r.to_hash.values.columnize }
      end
    end

    iso.desc "Add local iso files"
    iso.command :addlocalfile, :alf do |addfile|
      addfile.flag [:r, :repo]
      addfile.flag [:n, :name]
      addfile.arg_name "filename"
      addfile.action do |_, opts, args|
        require 'zadar/services/add_local_iso_file'

        failure! "Missing repository name" if opts[:repo].to_s.empty?
        call { Zadar::Services::AddLocalIsoFile.new(opts.merge(filename: args.first)) }
      end
    end

    iso.desc "List local iso files"
    iso.command :"listlocalfiles", :llf do |list|
      list.flag [:r, :repo]
      list.action do |_, options, _|
        require 'zadar/services/find_local_iso_files'

        failure! "Iso repository not specified" unless options[:repo]

        files =  Zadar::Services::FindLocalIsoFiles.new(options).call.files
        failure! "No iso files found" if files.empty?

        puts Zadar::Models::IsoLocalFile.columns.columnize
        files.each {|f| puts f.to_hash.values.columnize }
      end
    end

    iso.desc "Remove local iso repositories"
    iso.command :removerepo, :rr do |rm_repo|
      rm_repo.switch :delete
      rm_repo.action do |_, opts, args|
        require "zadar/services/remove_local_iso_repo"

        call { Zadar::Services::RemoveLocalIsoRepo.new(opts.merge(name: args.first)) }
      end
    end

    iso.desc "Remove local iso files"
    iso.command :removefile, :rf do |rm_file|
      rm_file.switch :delete
      rm_file.flag [:r, :repo]
      rm_file.arg_name 'iso file name'
      rm_file.action do |_, opts, args|
        require "zadar/services/remove_local_iso_file"

        call { Zadar::Services::RemoveLocalIsoFile.new(opts.merge(filename: args.first)) }
      end
    end
  end
end
