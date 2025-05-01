# Agent AI Base

![agent-ai-base](./agent-ai-base.png)

Agent AI Base is a foundational project designed to kickstart the development of AI-powered agents. This repository provides a modular and extensible structure to build, train, and deploy intelligent agents for various applications.

## Features

- **Modular Design**: Easily extend and customize components.
- **Scalability**: Built to handle small to large-scale AI projects.
- **Integration Ready**: Compatible with popular AI frameworks and tools.
- **Documentation**: Clear and concise documentation for ease of use.

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/agent-ai-base.git
    ```

## Building Docker Images

You can build Docker images for both CPU and GPU environments using the provided Dockerfiles.

### Build the CPU Image

1. Navigate to the project directory.
2. Run the following command:

    ```bash
    docker build -f Dockerfile.cpu -t agent-ai-base:cpu .
    ```

    or

    ```bash
    deploy.sh cpu
    ```

### Build the GPU Image

1. Ensure you have the necessary NVIDIA drivers and Docker setup for GPU support.
2. Run the following command:

    ```bash
    docker build -f Dockerfile.gpu -t agent-ai-base:gpu .
    ```

    or

    ```bash
    deploy.sh gpu
    ```

### Pull Prebuilt Images

You can also pull the prebuilt images directly from GitHub Container Registry:

- **CPU version**:

    ```bash
    docker pull 932362285414.dkr.ecr.eu-central-1.amazonaws.com/agent-ai-base:cpu
    ```

- **GPU version**:

    ```bash
    docker pull 932362285414.dkr.ecr.eu-central-1.amazonaws.com/agent-ai-base:gpu
    ```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch:

    ```bash
    git checkout -b feature-name
    ```

3. Commit your changes:

    ```bash
    git commit -m "Add feature-name"
    ```

4. Push to your branch:

    ```bash
    git push origin feature-name
    ```

5. Open a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For questions or support, please contact [your-email@example.com].
