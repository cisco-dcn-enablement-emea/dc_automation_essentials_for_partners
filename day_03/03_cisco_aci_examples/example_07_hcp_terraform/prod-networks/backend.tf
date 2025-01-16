terraform {
  cloud {
    organization = "spain-cn-lab"

    workspaces {
      name = "adealdag-hcp-demo-networks"
    }
  }
}
