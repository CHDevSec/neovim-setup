return {
  {
    "https://github.com/AvanteAI/avante.nvim",
    config = function()
      require("avante").setup({
        provider = "openai",
        openai = {
          api_key = os.getenv("OPENAI_API_KEY"),
          model = "gpt-4o",
        }
      })
    end
  }
}
