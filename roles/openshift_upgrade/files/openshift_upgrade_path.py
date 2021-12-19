#!/usr/bin/env python3

import json
import logging
import pprint
import requests
import sys

OPENSHIFT_GRAPH_URL = 'https://api.openshift.com/api/upgrades_info/v1/graph?channel=%s'
CHANNEL = 'channel'
STABLE = 'stable'
VERSION = 'version'
MAJOR = 4

class Node(object):

    def __init__(self, channel, version):
        self.version = version
        self.channel = channel
        self.outgoing_edges = set()

class Graph(object):

    def __init__(self):
        self.nodes = dict()

    def add_version(self, channel, version):
        if not version in self.nodes:
            node = Node(channel, version)
            self.nodes[version] = node

    def add_edge(self, from_version, to_version):
        from_node = self.nodes[from_version]
        to_node = self.nodes[to_version]
        from_node.outgoing_edges.add(to_node)

    def sort_versions(self, versions):
        versions.sort(key = lambda x: [int(y) for y in x.split('.')])

    def process_channel_reponse(self, channel, channel_response):
        node_list = []
        for node in channel_response["nodes"]:
            ver = node["version"]
            self.add_version(channel, ver)
            node_list.append(ver)

        for edge in channel_response["edges"]:
            from_version = node_list[edge[0]]
            to_version = node_list[edge[1]]
            self.add_edge(from_version, to_version)

    def get_latest_version_on_channel(self, channel):
        versions = list()
        for node in self.nodes.values():
            if node.channel == channel:
                versions.append(node.version)
        self.sort_versions(versions)
        return versions[-1]

    def find_upgrade_path(self, from_version, to_version):
        if not from_version in self.nodes:
            return False, []

        from_node = self.nodes[from_version]
        visited = set()
        queue = [ (from_node, []) ]

        # Breadth-first search
        while queue:
            node, path = queue.pop(0)
            if node in visited:
                continue
            visited.add(node)
            if node.version == to_version:
                return True, path
            else:
                for edge in node.outgoing_edges:
                    path_increment = {
                            CHANNEL: edge.channel,
                            VERSION: edge.version
                    }
                    queue.append((edge, path + [ path_increment ]))
        return False, []

    def show_graph(self):
        versions = list(self.nodes.keys())
        self.sort_versions(versions)
        for ver in versions:
            node = self.nodes[ver]
            edges = []
            for edge in node.outgoing_edges:
                edges.append(edge.version)
            self.sort_versions(edges)
            logging.debug("{} has outgoing edges to {}".format(ver, edges))

class Main(object):

    def main(self):
        logging.basicConfig(level=logging.INFO)

        from_version_arg, to_version_arg = self.read_program_arguments()

        to_version = to_version_arg.split(".")
        to_minor = int(to_version[1])

        if from_version_arg:
            from_version = from_version_arg.split(".")
            from_minor = int(from_version[1])
        else:
            from_minor = to_minor

        graph = self.build_graph(from_minor, to_minor)

        if len(to_version) == 2:
          channel = "%s-%i.%i" % (STABLE, MAJOR, to_minor)
          to_version_arg = graph.get_latest_version_on_channel(channel)
          if not from_version_arg:
              print(to_version_arg)
              sys.exit(0)

        found, path = graph.find_upgrade_path(from_version_arg, to_version_arg)
        logging.debug("Upgrade path {} {}".format(found, path))

        if found:
            print(json.dumps(path))
        else:
            logging.error("Upgrade path not found.")
            sys.exit(-1)

    def build_graph(self, from_minor, to_minor):
        graph = Graph()
        for i in range(from_minor, to_minor + 1):
            channel = "%s-%i.%i" % (STABLE, MAJOR, i)
            self.add_channel_to_graph(channel, graph)
        graph.show_graph()
        return graph

    def add_channel_to_graph(self, channel, graph):
        channel_url = OPENSHIFT_GRAPH_URL % (channel)
        channel_response = requests.get(channel_url)
        response_json = channel_response.json()

        if channel_response.status_code == 200:
            graph.process_channel_reponse(channel, response_json)
        else:
            pp = pprint.PrettyPrinter(indent=4)
            raise Exception("Failed to fetch data for channel %s. Response was: %s" %
                (self.url, pp.pformat(response_json)))

    def read_program_arguments(self):
        if len(sys.argv) <= 1:
            print("Usage:")
            print("{} CHANNEL_VERSION".format(sys.argv[0]))
            print("{} FROM_VERSION TO_VERSION".format(sys.argv[0]))
            sys.exit(-1)
        if len(sys.argv) == 2:
            return None, sys.argv[1]
        else:
            return sys.argv[1], sys.argv[2]

Main().main()
