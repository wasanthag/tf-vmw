terraform {
  backend "remote" {
    hostname = "https://tfe.lab.local:443"
    organization    = "wwt"
    workspaces {
      name  = "jenkins-tfe-vmw"
      }
  }
}
