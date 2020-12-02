from jinja2 import Template
import argparse
import yaml

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('--template-file', '-t', default='./config/templates/sys.config.jinja2')
    parser.add_argument('--config-file', '-c', default='./config/sys.config')
    parser.add_argument('--template-data-file', '-d', required=True)

    args = parser.parse_args()

    template_data = load_template_data(args.template_data_file)
    template = load_template(args.template_file)
    config = template.render(template_data)

    write_config(args.config_file, config)

def load_template(template_file):
    with open(template_file, 'r') as file:
        return Template(file.read())

def load_template_data(template_data_file):
    with open(template_data_file, 'r') as file:
        return yaml.load(file.read())

def write_config(config_file, config):
    with open(config_file, 'w') as file:
        file.write(config)

if __name__ == '__main__':
    main()
