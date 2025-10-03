return {
    "tpope/vim-dadbod",
    optional = true,
    dependencies = {"kristijanhusak/vim-dadbod-ui", "kristijanhusak/vim-dadbod-completion"},
    opts = {},
    cmd = {"DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo"}
}