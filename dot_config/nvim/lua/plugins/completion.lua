return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'archie-judd/blink-cmp-words' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },
        ghost_text = { enabled = true },
        menu = {
          auto_show = false,
          draw = {
            treesitter = { 'lsp' },
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "kind" } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu")
                      .blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu")
                      .blink_components_highlight(ctx)
                end,
              },
            },
          }
        },
        trigger = {
          -- Recommended by minuet-ai to avoid unnecessary request
          prefetch_on_insert = false
        }
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'minuet' },
        providers = {
          thesaurus = {
            name = 'blink-cmp-words',
            module = 'blink-cmp-words.thesaurus'
          },
          dictionary = {
            name = 'blink-cmp-words',
            module = 'blink-cmp-words.dictionary'
          },
          -- AI auto-complete
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            async = true,
            -- Should match minuet.config.request_timeout * 1000,
            -- since minuet.config.request_timeout is in seconds
            timeout_ms = 3000,
            score_offset = 50, -- Gives minuet higher priority among suggestions
          },
        },
        per_filetype = {
          text = { 'dictionary', 'thesaurus' },
          markdown = { 'dictionary', 'thesaurus' },
          css = { 'lsp' },
          scss = { 'lsp' },
          sass = { 'lsp' },
        }
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  { 'xzbdmw/colorful-menu.nvim' }
}
