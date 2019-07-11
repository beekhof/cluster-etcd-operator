package main

import (
	"flag"
	"fmt"

	"github.com/openshift/cluster-etcd-operator/pkg/version"
	"github.com/spf13/cobra"
)

var (
	versionCmd = &cobra.Command{
		Use:   "version",
		Short: "Print the version number of Setup Etcd Environment",
		Long:  `All software has versions. This is Setup Etcd Environment's.`,
		Run:   runVersionCmd,
	}
)

func init() {
	rootCmd.AddCommand(versionCmd)
}

func runVersionCmd(cmd *cobra.Command, args []string) {
	flag.Set("logtostderr", "true")
	flag.Parse()
	info := version.Get()

	program := "Setup Etcd Environment"
	v := info.GitVersion + " - " + info.GitCommit + " (" + info.BuildDate + ")"

	fmt.Println(program, v)
}
