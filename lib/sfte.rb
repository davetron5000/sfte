def cat(global_options,options,args)
  all = options[:a]
  base = options[:b]
  args.each do |arg|
    file = File.open("#{base}/target/surefire-reports/#{arg}.txt")
    index = 0
    file.readlines.each do |line|
      if all
        puts line
      else
        puts line if index == 5 || index == 4
        puts line if (line =~ /at #{global_options[:p]}/)
        puts line if (line =~ /^\s*$/)
      end
      index += 1
    end

  end
end

def maven(global_options,options,args)

  files = []
  report_dir = nil

  argline = options[:d]
  argline = args.join(" ") if args && !args.empty?
  puts "Running mvn #{argline}" if options[:v]
  argline = "-f #{options[:f]} #{argline}" if options[:f]

  IO.popen("mvn #{argline}") do |maven|
    maven.sync = true

    in_test_block = false

    while ! maven.eof?
      line = maven.readline
      puts line if options[:v] == 'very'
      if line =~ /\[INFO\] Surefire report directory: (.*)$/
        report_dir = $1.chomp
        puts "Finding test output in #{report_dir}" if options[:v]
      end
      if in_test_block
        if line =~ /^\s*$/
          done = true
        else
          files << line.chomp.gsub(/^  [^\(]*\(/,'').gsub(/\)/,'')
        end
      end
      in_test_block = false if line =~/^\s*$/
      break if line =~ /There are test failures/;
      if line =~ /Failed tests:/ || line =~ /Tests in error:/
        in_test_block = true
      end
    end
  end
  if files.length > 0
    efm(global_options,options,files.collect {|file| "#{report_dir}/#{file}.txt"})
  end
end

def efm(global_options,options,args)
  args.each do |arg|
    base_dir = arg.gsub(/\/target.*$/,'')
    File.open(arg) do |file|
      errors = 0
      message = ""
      file.readlines.each do |line|
        message = line if line =~ /^\S/
          if line =~ /^\s*at (#{global_options[:p]}.*)\(.*:(\d+)\)/
            line_number = $2
        parts = $1.split(/\./)
        parts.pop
        dir = "main"
        dir = "test" if (parts[-1] =~ /^Test/) || (parts[-1] =~ /^IntTest/) || (parts[-1] =~ /^ExhaustiveTest/)
        puts "#{base_dir}/src/#{dir}/java/#{parts.join('/')}.java:#{line_number}: #{message}"
        errors += 1
          end
      end
    end
  end
end
