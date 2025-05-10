-- ~/.config/nvim/ftplugin/java.lua
local jdtls_status_ok, jdtls = pcall(require, "jdtls")
if not jdtls_status_ok then
  vim.notify("nvim-jdtls not found", vim.log.levels.WARN)
  return
end

local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

-- Find the jdtls executable installed by Mason
local jdtls_path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

-- Lombok setup (if Mason installed jdtls, lombok.jar is often included)
local lombok_jar_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
local jvm_args = {}
if vim.fn.filereadable(lombok_jar_path) == 1 then
    table.insert(jvm_args, ('-javaagent:%s'):format(lombok_jar_path))
end


-- Location of java-debug-adapter and vscode-java-test jars (installed by Mason)
local java_debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
local vscode_java_test_path = vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"

local bundles = {}
local java_debug_bundle = vim.fn.glob(java_debug_adapter_path, true) -- true to return as string
if java_debug_bundle ~= "" then
    table.insert(bundles, java_debug_bundle)
end

local vscode_java_test_bundles = vim.fn.glob(vscode_java_test_path, true)
if vscode_java_test_bundles ~= "" then
    -- glob can return multiple paths separated by newline
    for _, bundle_path in ipairs(vim.split(vscode_java_test_bundles, "\n")) do
        if bundle_path ~= "" then
            table.insert(bundles, bundle_path)
        end
    end
end


local config = {
  cmd = { jdtls_path, "-data", workspace_path, "--jvm-arg=" .. table.concat(jvm_args, ",")},
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),
  settings = {
    java = {
      -- Ensure these settings are correct for your environment
      -- eclipse = {
      --   downloadSources = true,
      -- },
      -- configuration = {
      --   updateBuildConfiguration = "interactive",
      -- },
      -- redhat = {
      --   telemetry = { enabled = false },
      -- },
      -- completion = {
      --   favoriteStaticMembers = {
      --     "org.hamcrest.MatcherAssert.assertThat",
      --     "org.hamcrest.Matchers.*",
      --     "org.junit.jupiter.api.Assertions.*",
      --   },
      -- },
      -- sources = {
      --   organizeImports = {
      --     starThreshold = 9999,
      --     staticStarThreshold = 9999,
      --   },
      -- },
      -- codeGeneration = {
      --   toString = {
      --     template = "${member.name()}=${member.value()}, "
      --   }
      -- }
    }
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
  },
  on_attach = function(client, bufnr)
    -- Your on_attach function from your lspconfig (or a specific one for Java)
    require("custom.configs.lspconfig").on_attach(client, bufnr) -- reuse your on_attach

    -- Enable keybindings for nvim-jdtls commands
    require("jdtls").setup_dap_main_class_configs() -- For debugging main classes
    require("jdtls.dap").setup_dap_action_map_text() -- For visual DAP actions
    -- Example jdtls specific keymaps:
    vim.keymap.set("n", "<leader>jo", "<Cmd>lua require('jdtls').organize_imports()<CR>", { buffer = bufnr, desc = "JDTLS Organize Imports" })
    vim.keymap.set("n", "<leader>jt", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", { buffer = bufnr, desc = "JDTLS Test Nearest Method" })
    vim.keymap.set("n", "<leader>jT", "<Cmd>lua require('jdtls').test_class()<CR>", { buffer = bufnr, desc = "JDTLS Test Class" })
    vim.keymap.set("v", "<leader>je", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { buffer = bufnr, desc = "JDTLS Extract Variable" })
    vim.keymap.set("n", "<leader>je", "<Cmd>lua require('jdtls').extract_variable()<CR>", { buffer = bufnr, desc = "JDTLS Extract Variable" })
    vim.keymap.set("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { buffer = bufnr, desc = "JDTLS Extract Constant" })
    vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { buffer = bufnr, desc = "JDTLS Extract Method" })
  end,
}

-- This starts the jdtls server and attaches to current buffer
jdtls.start_or_attach(config)
