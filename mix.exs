defmodule NervesSystemRadxaCm3.MixProject do
  use Mix.Project

  @github_organization "sportalliance"
  @app :nerves_system_radxa_cm3
  @source_url "https://github.com/#{@github_organization}/#{@app}"
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      preferred_cli_env: %{
        docs: :docs,
        "hex.build": :docs,
        "hex.publish": :docs
      }
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "#{@github_organization}/#{@app}"}
      ],
      build_runner_opts: build_runner_opts(),
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      # The :env key is an optional experimental feature for adding environment
      # variables to the crosscompile environment. These are intended for
      # llvm-based tooling that may need more precise processor information.
      env: [
        {"TARGET_ARCH", "aarch64"},
        {"TARGET_CPU", "cortex_a55"},
        {"TARGET_OS", "linux"},
        {"TARGET_ABI", "gnu"},
        {"TARGET_GCC_FLAGS",
         "-mabi=lp64 -fstack-protector-strong -mcpu=cortex-a55 -fPIE -pie -Wl,-z,now -Wl,-z,relro"}
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.5.4 or ~> 1.6.0 or ~> 1.7.15 or ~> 1.8 or ~> 1.9", runtime: false},
      {:nerves_system_br, "1.21.1", runtime: false},
      {:nerves_toolchain_aarch64_nerves_linux_gnu, "~> 1.6.1", runtime: false},
      {:nerves_system_linter, "~> 0.4", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.22.0", only: :docs, runtime: false},
    ]
  end

  defp description do
    """
    Nerves System - Radxa CM3, Pine64 SOQuartz
    """
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp package do
    [
      files: package_files(),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp package_files do
    [
      "fwup_include",
      "linux",
      "rootfs_overlay",
      "uboot",
      "busybox.fragment",
      "CHANGELOG.md",
      "fwup-revert.conf",
      "fwup.conf",
      "LICENSE",
      "mix.exs",
      "nerves_defconfig",
      "post-build.sh",
      "post-createfs.sh",
      "README.md",
      "VERSION"
    ]
  end
  
  defp prepare_deps(_) do
    {_, 0} = System.cmd(
      "/bin/sh",
      [
        "-c",
        "cp patches/buildroot/* deps/nerves_system_br/patches/buildroot/"
      ],
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true
    )
  end
  
  defp aliases do
    [
      loadconfig: [&bootstrap/1],
      compile: [&prepare_deps/1,"compile"]
    ]
  end

  # Copy the images referenced by docs, since ex_doc doesn't do this.
  defp copy_images(_) do
    File.cp_r("assets", "doc/assets")
  end

  defp build_runner_opts() do
    # Download source files first to get download errors right away.
    [make_args: primary_site() ++ ["source", "all", "legal-info"]]
  end

  defp primary_site() do
    case System.get_env("BR2_PRIMARY_SITE") do
      nil -> []
      primary_site -> ["BR2_PRIMARY_SITE=#{primary_site}"]
    end
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "target")
    end
  end
end
